#!/usr/bin/envy ruby
require 'open-uri'

DOWNLOAD_DIR = "~/Downloads"
module Handler
  class << self
    def download application
      filepath = File.join DOWNLOAD_DIR, application.filename
      open(File.expand_path(filepath), 'wb') do |file|
        file << open(application.url).read
      end
      puts "#{application.name} download has finished..."
      filepath
    end

    def mount dmg_file
      puts "mounting file"
      %x(hdiutil mount #{dmg_file})
    end

    def unmount mounted_path
      %x(hdiutil unmount \"#{mounted_path}\")
    end

    def unzip zip_file
      puts "unziping the file"
      %x(unzip #{zip_file})
    end

    def install extension, filepath
      case extension
      when ".dmg"
        mount filepath
      when ".zip"
        unzip filepath
      end

      #second_step: deal with pkg, app
    end

    def app_command app_path
      %x(sudo cp -R \"#{app_path}\" /Applications)
    end

    def pkg_command pkg_path
      %x(sudo installer -package \"#{pkg_path}\" -target "/Volumes/Macintosh HD")
    end
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

  def extension
    File.extname filename
  end
end

applications = [
  Application.new("Dropbox", "https://dl.dropboxusercontent.com/u/17/Dropbox%202.0.16.dmg"),
  Application.new("SublimeText2", ""),
  Application.new("iTerm2", "https://iterm2.googlecode.com/files/iTerm2-1_0_0_20130324-LeopardPPC.zip"),
  Application.new("Firefox", "http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/21.0/mac/en-US/Firefox%2021.0.dmg"),
  Application.new("Chrome", "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"),
  Application.new("Vagrant", ""),
  Application.new("TeamViewer", "")
]

applications.each do |app|
  filepath = Handler.download app
  Handler.install app.extension, filepath
end


