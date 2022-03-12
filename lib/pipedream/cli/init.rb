class Pipedream::CLI
  class Init < Sequence
    # Ugly, this is how I can get the options from to match with this Thor::Group
    def self.cli_options
      [
        [:name, desc: "CodePipeline project name."],
        [:mode, desc: "Modes: light or full", default: "light" ],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:template, desc: "Custom template to use."],
        [:template_mode, desc: "Template mode: replace or additive."],
      ]
    end
    cli_options.each { |o| class_option(*o) }

    def setup_template_repo
      return unless @options[:template]&.include?('/')

      sync_template_repo
    end

    def set_source_path
      return unless @options[:template]

      custom_template = "#{ENV['HOME']}/.pipedream/templates/#{full_repo_name}"

      if @options[:template_mode] == "replace" # replace the template entirely
        override_source_paths(custom_template)
      else # additive: modify on top of default template
        default_template = File.expand_path("../../template", __FILE__)
        override_source_paths([custom_template, default_template])
      end
    end

    def copy_project
      puts "Initialize pipedream project in .pipedream"

      excludes = %w[.git]
      if @options[:mode] == "light"
        excludes += %w[
          settings.yml
          sns.rb
        ]
      end
      pattern = Regexp.new(excludes.join('|'))

      if @options[:template]
        directory ".", ".pipedream", exclude_pattern: pattern
      else
        directory ".", exclude_pattern: pattern
      end
    end

  private
    def project_name
      inferred_name = File.basename(Dir.pwd).gsub('_','-').gsub(/[^0-9a-zA-Z,-]/, '')
      @options[:name] || inferred_name
    end

    def project_github_repo
      default = "user/repo"
      return default unless File.exist?(".git/config") && git_installed?

      url = `git config --get remote.origin.url`.strip
      repo = Dsl::Pipeline::Github.extract_repo_source(url)
      repo == '' ? default : repo
    end
  end
end