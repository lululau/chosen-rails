require 'thor'
require 'json'

class SourceFile < Thor
  include Thor::Actions

  desc 'fetch source files', 'fetch source files from GitHub'
  def fetch remote, branch
    self.destination_root = 'vendor/assets'
    get "#{remote}/raw/#{branch}/public/chosen-sprite.png", 'images/chosen-sprite.png'
    get "#{remote}/raw/#{branch}/public/chosen-sprite@2x.png", 'images/chosen-sprite@2x.png'
    get "#{remote}/raw/#{branch}/less/chosen.css.less", 'stylesheets/chosen.css.less'
    get "#{remote}/raw/#{branch}/coffee/lib/abstract-chosen.coffee", 'javascripts/lib/abstract-chosen.coffee'
    get "#{remote}/raw/#{branch}/coffee/lib/select-parser.coffee", 'javascripts/lib/select-parser.coffee'
    get "#{remote}/raw/#{branch}/coffee/chosen.jquery.coffee", 'javascripts/chosen.jquery.coffee'
    get "#{remote}/raw/#{branch}/coffee/chosen.proto.coffee", 'javascripts/chosen.proto.coffee'
    get "#{remote}/raw/#{branch}/package.json", 'package.json'
    bump_version
  end

  desc 'eject class from closure', 'eject javascript library class from closure'
  def eject_javascript_class_from_closure
    self.destination_root = 'vendor/assets'
    inside destination_root do
      append_to_file 'javascripts/lib/abstract-chosen.coffee' do
        "\nwindow.AbstractChosen = AbstractChosen\n"
      end
      append_to_file 'javascripts/lib/select-parser.coffee' do
        "\n\nwindow.SelectParser = SelectParser\n"
      end
    end
  end

  desc 'clean up useless files', 'clean up useless files'
  def cleanup
    self.destination_root = 'vendor/assets'
    remove_file 'package.json'
  end

  protected

  def bump_version
    inside destination_root do
      package_json = JSON.load(File.open('package.json'))
      version = package_json['version']
      gsub_file '../../lib/chosen-rails/version.rb', /CHOSEN_VERSION\s=\s'(\d|\.)+'$/ do |match|
        %Q{CHOSEN_VERSION = '#{version}'}
      end
    end
  end
end
