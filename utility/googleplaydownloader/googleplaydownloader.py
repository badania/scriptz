#! /usr/bin/python
# -*- coding: utf-8 -*-

"""
GooglePlayDownloader
Copyright (C) 2013   Erwan JACQ

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import wx, platform, os, sys, thread
from wx.lib.mixins.listctrl import ListCtrlAutoWidthMixin
import wx.lib.hyperlink as hl

try :
  os.chdir(os.path.dirname(sys.argv[0])) #Go to current folder
except: pass

#Import external libs
ext_libs_path = os.path.join(os.getcwd(), "ext_libs")
sys.path.append(ext_libs_path)
from ext_libs.googleplay_api.googleplay import GooglePlayAPI #GooglePlayAPI
from ext_libs.androguard.core.bytecodes import apk as androguard_apk #Androguard


config = {"download_folder_path" : os.path.join(os.getcwd(),"apk_downloaded")}

def get_googleplay_api():
  #default credentials
  LANG            = "fr_FR"
  ANDROID_ID      = "32AA74CDC05B26A9" 
  GOOGLE_LOGIN    = "tefuhkog@gmail.com"
  GOOGLE_PASSWORD = "tyuiop65"
  AUTH_TOKEN = None

  api = GooglePlayAPI(androidId=ANDROID_ID, lang=LANG)
  api.login(GOOGLE_LOGIN, GOOGLE_PASSWORD, AUTH_TOKEN)
  return api
  
def sizeof_fmt(num):
  for x in ['bytes','KB','MB','GB','TB']:
    if num < 1024.0:
        return "%3.1f%s" % (num, x)
    num /= 1024.0
    
#List autoresize
class AutoWidthListCtrl(wx.ListCtrl, ListCtrlAutoWidthMixin):
  def __init__(self, parent, ID, style):
    thestyle = style
    wx.ListCtrl.__init__(self, parent, ID, style=thestyle)
    ListCtrlAutoWidthMixin.__init__(self)
  
  def autoresize(self):
    for i in range(self.GetColumnCount()):
      #Autoresize column using header
      self.SetColumnWidth(i, wx.LIST_AUTOSIZE_USEHEADER)
      width1 = self.GetColumnWidth(i)
      
      #Autoresize column using content
      self.SetColumnWidth(i, wx.LIST_AUTOSIZE)
      width2 = self.GetColumnWidth(i)
      
      if width2 < width1:
        self.SetColumnWidth(i, wx.LIST_AUTOSIZE_USEHEADER)
        
  def fill_headers(self, headers):
    for i, header in enumerate(headers):
      self.InsertColumn(i, u"%s" % header)
      
    
def analyse_local_apks(list_of_apks, playstore_api, download_folder_path, dlg, return_function):
  list_apks_to_update = []
  for position, filename in enumerate(list_of_apks):
    wx.CallAfter(dlg.Update, position, "%i/%i : %s\nPlease Wait..." %(position+1, len(list_of_apks), filename))
    
    #Get APK info from file on disk
    filepath = os.path.join(download_folder_path, filename)
    a = androguard_apk.APK(filepath)
    apk_version_code = a.get_androidversion_code()
    packagename = a.get_package()
    
    #Get APK info from store
    m =playstore_api.details(packagename)
    doc = m.docV2
    store_version_code = doc.details.appDetails.versionCode
    
    #Compare
    if int(apk_version_code) != int(store_version_code) and int(store_version_code) != 0:
      #Add to the download list
      list_apks_to_update.append([packagename, filename, int(apk_version_code), int(store_version_code)])
  
  wx.CallAfter(dlg.Update, position+1)   #Reach end of progress dialog
  wx.CallAfter(return_function, list_apks_to_update)

  
def download_selection(playstore_api, list_of_packages_to_download, dlg, return_function):
  failed_downloads = []
  for position, item in enumerate(list_of_packages_to_download):
    packagename, filename = item
    
    #Check for download folder
    download_folder_path = config["download_folder_path"]
    if not os.path.isdir(download_folder_path):
      os.mkdir(download_folder_path)
      
    # Get the version code and the offer type from the app details
    m = playstore_api.details(packagename)
    doc = m.docV2
    title = doc.title
    vc = doc.details.appDetails.versionCode
    
    #Update progress dialog
    wx.CallAfter(dlg.Update, position, "%i/%i : %s\n%s\nSize : %s\nPlease Wait..." %(position+1, len(list_of_packages_to_download), title, packagename, sizeof_fmt(doc.details.appDetails.installationSize)))

    # Download
    try:
      data = playstore_api.download(packagename, vc)
    except Exception, exc:
      print "Error while downloading %s : %s" % (packagename, exc)
      failed_downloads.append(item)
    else:
      if filename == None:
        filename = packagename + ".apk"
      filepath = os.path.join(download_folder_path,filename)
        
      open(filepath, "wb").write(data)
      
  wx.CallAfter(dlg.Update, position+1)   #Reach end of progress dialog
  wx.CallAfter(return_function,failed_downloads)
  

def softwareID(query) :
  if query == "name":
    return u"Google Play Downloader"
  if query == "version":
    return u"0.1"
  if query == "copyright":
    return u"Tuxicoman"

class MainPanel(wx.Panel):
  def __init__(self, parent):
    wx.Panel.__init__(self, parent, -1)
    self.playstore_api = parent.application.playstore_api

    #Search
    search_title = wx.StaticText(self, -1, u"Search :")
    search_entry = wx.SearchCtrl(self, -1, style=wx.TE_PROCESS_ENTER)
    search_entry.SetDescriptiveText(u"Search")
    self.Bind(wx.EVT_TEXT_ENTER, lambda e: self.search(results_list, search_entry.GetValue(), nb_results=20), search_entry)

    #Search Layout
    searchbox = wx.BoxSizer(wx.VERTICAL)
    searchbox.Add(search_title)
    searchbox.Add(search_entry, 0, wx.EXPAND|wx.ADJUST_MINSIZE)
    
    #Results
    results_title = wx.StaticText(self, -1, u"Results :")
    results_list = AutoWidthListCtrl(self, -1, style=wx.LC_REPORT|wx.BORDER_SUNKEN)
    results_list.headers =[ "Title",
      "Creator",
      "Size",
      "Last update",
      "Version Code",
      "Price",
      "Rating",
      "Num Downloads",
      ]
          
    results_list.fill_headers(results_list.headers)
    results_list.autoresize()
    
    #Results Layout
    resultsbox = wx.BoxSizer(wx.VERTICAL)
    resultsbox.Add(results_title)
    resultsbox.Add(results_list, 1, wx.EXPAND|wx.ADJUST_MINSIZE)

    
    #Buttons
    self.download_button = wx.Button(self, -1, "Download APK(s) selected")
    self.download_button.Disable()
    self.Bind(wx.EVT_BUTTON, lambda e: self.prepare_download_selection(results_list), self.download_button)
    self.update_button = wx.Button(self, -1, "Search updates for local APK(s)")
    self.Bind(wx.EVT_BUTTON, self.prepare_analyse_apks, self.update_button )
    
    #Buttons layout
    buttonsbox = wx.BoxSizer(wx.HORIZONTAL)
    buttonsbox.Add(self.download_button, 1, wx.ALIGN_LEFT|wx.TOP,  border=3)
    buttonsbox.Add(self.update_button, 1, wx.ALIGN_RIGHT|wx.TOP,  border=3)
    
    #Credits
    creditsbox = wx.BoxSizer(wx.HORIZONTAL)
    creditsbox.AddMany([wx.StaticText(self, -1, u"Credits : "), hl.HyperLinkCtrl(self, wx.ID_ANY, u"Tuxicoman", URL="http://tuxicoman.jesuislibre.net"), wx.StaticText(self, -1, u" / GooglePlay unofficial API : "), hl.HyperLinkCtrl(self, wx.ID_ANY, u"Emilien Girault", URL="http://www.segmentationfault.fr")])
  
    #Layout
    bigbox = wx.BoxSizer(wx.VERTICAL)
    bigbox.Add(searchbox, 0, wx.EXPAND|wx.ADJUST_MINSIZE)
    bigbox.Add(resultsbox, 1, wx.EXPAND|wx.ADJUST_MINSIZE)
    bigbox.Add(buttonsbox, 0, wx.EXPAND|wx.ADJUST_MINSIZE)
    bigbox.Add(creditsbox, 0)

    
    self.SetSizer(bigbox)
    self.SetMinSize((700,300))
    search_entry.SetFocus()
    
  def prepare_analyse_apks(self, event):
    if True:#self.ask_download_folder_path() == True:
      download_folder_path = config["download_folder_path"]
      list_of_apks = [filename for filename in os.listdir(download_folder_path) if os.path.splitext(filename)[1] == ".apk"]
      dlg = wx.ProgressDialog("Updating APKs",
                                 "_" * 30 + "\n"*2,
                                 maximum = len(list_of_apks),
                                 parent=self,
                                 style = wx.PD_AUTO_HIDE 
                                 )
      thread.start_new_thread(analyse_local_apks, (list_of_apks, self.playstore_api, download_folder_path, dlg, self.prepare_download_updates))


        
    
  def search(self, results_list, search_string, nb_results):
    #Query results
    results = self.playstore_api.search(search_string, nb_results=nb_results).doc
    if len(results) > 0:
      results = results[0].child
    #else : No results found !
    
    #Fill list in GUI
    results_list.ClearAll()
    results_list.data = []
    
    results_list.fill_headers(results_list.headers)
    
    for i, result in enumerate(results):
      l = [ result.title,
            result.creator,
            sizeof_fmt(result.details.appDetails.installationSize),
            result.details.appDetails.uploadDate,
            result.details.appDetails.versionCode,
            result.offer[0].formattedAmount,
            "%.2f" % result.aggregateRating.starRating,
            result.details.appDetails.numDownloads]
                
      item = results_list.InsertStringItem(i, "")
      for j, text in enumerate(l):
        results_list.SetStringItem(item,j,u"%s" % text)
        
    
      #Associate data
      results_list.data.append(result.docid)
      results_list.SetItemData(item, i)
      
      #select first item
      if i == 0:
        results_list.SetItemState(item, wx.LIST_STATE_SELECTED, wx.LIST_STATE_SELECTED)
        results_list.EnsureVisible(item)
      
      
    results_list.autoresize()
    
    #Disable button if there is no result
    if results_list.GetFirstSelected() != -1:
      self.download_button.Enable()
    else:
      self.download_button.Disable()
      
  def after_download(self, failed_downloads):
    #Info message
    if len(failed_downloads) == 0 :
      message = "Download complete"
    else:
      message = "A few packages could not be downloaded :"
      for item in failed_downloads:
        package_name, filename = item
        if filename !=None :
          message += "\n%s : %s" % (filename, package_name)
        else:
          message += "\n%s" % package_name
      
    #Show info dialog
    dlg = wx.MessageDialog(self, message,'Download report', wx.OK | wx.ICON_INFORMATION)
    dlg.ShowModal()
    dlg.Destroy()
      
  def ask_download_folder_path(self):
    dlg = wx.DirDialog(self, "Choose a download folder:", style=wx.DD_DEFAULT_STYLE)
    return_value = dlg.ShowModal()
    dlg.Destroy()
    if return_value == wx.ID_OK :
      config["download_folder_path"] = dlg.GetPath()
      return True
    else:
      return False
    
  def prepare_download_selection(self, results_list):
    #Get list of packages selected
    list_of_packages_to_download = []
    selected_item = results_list.GetFirstSelected()
    while selected_item != -1 :
      packagename = results_list.data[results_list.GetItemData(selected_item)]
      list_of_packages_to_download.append([packagename, None])
      selected_item = results_list.GetNextSelected(selected_item)
    
    if len(list_of_packages_to_download) > 0:
      if self.ask_download_folder_path() == True:
        dlg = wx.ProgressDialog("Downloading APKs",
                                 " " * 30 + "\n"*4,
                                 maximum = len(list_of_packages_to_download),
                                 parent=self,
                                 style = wx.PD_CAN_ABORT| wx.PD_AUTO_HIDE
                                 )
        thread.start_new_thread(download_selection, (self.playstore_api, list_of_packages_to_download, dlg, self.after_download))

      
  def prepare_download_updates(self, list_apks_to_update):
    
    if len(list_apks_to_update) > 0: 
      list_of_packages_to_download = []
      
      #Ask confirmation before downloading
      message = u"The following applications will be updated :"
      for packagename, filename, apk_version_code, store_version_code in list_apks_to_update :
        message += u"\n%s Version : %s -> %s" % (filename ,apk_version_code, store_version_code)
        list_of_packages_to_download.append([packagename, filename])
      message += "\n\nDo you agree?"
      dlg = wx.MessageDialog(self, message, 'Updating APKs', wx.ICON_INFORMATION|wx.YES_NO )
      return_value = dlg.ShowModal()
      dlg.Destroy()
      
      if return_value == wx.ID_YES :
        #Progress Dialog
        dlg = wx.ProgressDialog("Updating APKs",
                                 " " * 30 + "\n"*4,
                                 maximum = len(list_of_packages_to_download),
                                 parent=self,
                                 style = wx.PD_CAN_ABORT|wx.PD_AUTO_HIDE
                                 )
        thread.start_new_thread(download_selection, (self.playstore_api, list_of_packages_to_download, dlg, self.after_download))

    
class MainFrame(wx.Frame):      

  def __init__(self, parent, title):
    wx.Frame.__init__(self, None, -1, title, pos=wx.DefaultPosition, style=wx.DEFAULT_FRAME_STYLE)
    #self.SetDoubleBuffered(True) #This seems to eat CPU on Windows :-(
    self.application = parent
    self.panel = MainPanel(self)
  
    #Layout
    self.sizer = wx.BoxSizer(wx.VERTICAL)
    self.sizer.Add(self.panel, 1, wx.EXPAND|wx.ALL,  border=10)
    self.SetSizer(self.sizer)
    self.Fit()
    self.CenterOnScreen()

class App(wx.App):
  def OnInit(self):
    #Connect to GooglePlay
    self.playstore_api = get_googleplay_api()
  
    title=u"%s %s" % (softwareID("name"), softwareID("version"))
    self.SetAppName(softwareID("name"))
    fen = MainFrame(self, title)  
    fen.SetIcon(wx.Icon("img/icon.ico", wx.BITMAP_TYPE_ICO))
    fen.Show(True)
    self.SetTopWindow(fen)
    return True

if __name__ == '__main__':
    
  if platform.system() == 'Linux' :
    app = App() 
  else :
    app = App(redirect=False)
  if platform.system() == 'Windows' :
    try :
      import win32event
      mutex = win32event.CreateMutex(None, 1, libutils.softwareID("name"))
    except : pass
  
  #Launch GUI
  app.MainLoop()
