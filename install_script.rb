#!/usr/bin/envy ruby
require 'open-uri'

DOWNLOAD_DIR = "~/Downloads"
class Handler
  def download application
    open(File.expand_path(DOWNLOAD_DIR, application.name), 'wb') do |file|
      file << open(application.url).read
    end
  end

  def mount dmg_file
    %x(hdiutil mount #{dmg_file})
  end

  def unmount mounted_path
    %x(hdiutil unmount \"#{mounted_path}\")
  end

  def unzip zip_file
    %x(unzip #{zip_file})
  end

  def install name, extension
    #first_step: deal with dmg, zip
    #second_step: deal with pkg, app
  end

  def app_command app_path
    %x(sudo cp -R \"#{app_path}\" /Applications)
  end

  def pkg_command pkg_path
    %x(sudo installer -package \"#{pkg_path}\" -target "/Volumes/Macintosh HD")
  end
end

class Application

  attr_reader :url, :name

  def initialize name, url
    @name, @url = name, url
  end

  def filename
    url.split('/').last
  end
end

applications = [Application.new("dropbox", "https://dl.dropboxusercontent.com/u/17/Dropbox%202.0.16.dmg"),
                Application.new("", ""),
                Application.new("", "")
               ]
