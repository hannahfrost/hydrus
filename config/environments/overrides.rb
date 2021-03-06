# Override make_solr_connection() so that we don't need certs in dev and test.
if %w(development test).include?(Rails.env)
  module Dor
    class Configuration
      def make_solr_connection(add_opts = {})
        opts = Config.solrizer.opts.merge(add_opts).merge(:url => Config.solrizer.url)
        ::RSolr.connect(opts).extend(RSolr::Ext::Client)
      end
    end
  end
end


Dor::Config.configure do

  load_yaml_config = lambda { |yaml_file|
    full_path = File.expand_path(File.join(File.dirname(__FILE__), '..', yaml_file))
    yaml      = YAML.load(File.read full_path)
    return yaml[Rails.env]
  }

  fedora do
    # Set the fedora URL with user and password info.
    yaml = load_yaml_config.call('fedora.yml')
    user = yaml['user']
    pw   = yaml['password']
    url yaml['url'].sub /:\/\//, "://#{user}:#{pw}@"
  end

  yaml = load_yaml_config.call('solr.yml')
  solrizer.url yaml['url']
    
  workflow.url 'http://lyberservices-dev.stanford.edu/workflow/'
  
end
