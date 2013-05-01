# -*- coding: utf-8 -*-
require 'webrick'

require 'thor'

require "rubygems"
require "rubygems/mirror/command"
require "rubygems/mirror/fetcher"

module Rubygems
  module Mirror
    module Command
      class CLI < Thor

        DEFAULT_CONFIG = [{
              "from" => "http://production.s3.rubygems.org",
              "to" => File.join(Gem.user_home, '.gem', "rubygems"),
              "parallelism" => 10,
          }]

        BASE_FILES = [
          "latest_specs.#{Gem.marshal_version}.gz",
          "Marshal.#{Gem.marshal_version}.Z",
          "yaml",
          "quick/latest_index.rz",
        ]

        GEMSPECS_DIR = "quick/Marshal.#{Gem.marshal_version}/"

        desc "fetch", "fetch all the necessary files to the server."
        def fetch
          fetch_allgems
          fetch_basefile
          fetch_gemspecs
        end

        desc "server [port]", "start mirror server."
        def server(port = 4000)
          WEBrick::HTTPServer.new(:DocumentRoot => to, :Port => port).start
        end

        desc "fetch_allgems", "fetch only gems."
        def fetch_allgems
          config_file
          say "fetch_allgems start!", :GREEN
          Gem::Commands::MirrorCommand.new.execute
          say "fetch_allgems end!", :GREEN
        end

        desc "fetch_gemspecs", "fetch only gemspec files."
        def fetch_gemspecs
          say "fetch gemspecs start!", :GREEN
          Dir::foreach(File.join(to,'gems')) do |filename|
            next if filename == "." or filename == ".."
            gem_name = File.basename filename, ".gem"
            say " -> #{gem_name}.gemspec.rz", :BLUE
            _fetch(File.join(GEMSPECS_DIR, "#{gem_name}.gemspec.rz"))
          end
          say "fetch gemspecs end!", :GREEN
        end

        desc "fetch_basefiles", "fetch only base files."
        def fetch_basefiles
          say "fetch basefiles start!", :GREEN
          BASE_FILES.each do |filename|
            say " -> #{filename}", :BLUE
            _fetch(filename)
          end
          say "fetch basefiles end!", :GREEN
        end

        private

        def _fetch(filename)
          @fetcher ||= Gem::Mirror::Fetcher.new
          @fetcher.fetch(File.join(from, filename), File.join(to, filename))
        end

        def from
          mirror['from']
        end

        def to
          mirror['to']
        end

        def mirror
          @mirror ||=
            begin
              mirrors = YAML.load_file config_file
              mirrors.first
            end
        end

        def config_file
          _config_file = File.join Gem.user_home, '.gem', '.mirrorrc'
          create_config(_config_file) unless File.exist? _config_file
          _config_file
        end

        def create_config(config_file)
          File.write(config_file, DEFAULT_CONFIG.to_yaml)
        end
      end
    end
  end
end
