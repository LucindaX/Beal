require 'sinatra/base'
require 'github_hook'
require 'ostruct'
require 'time'

class Blog < Sinatra::Base

  use GithubHook

  set :root, File.expand_path('../../', __FILE__)
  set :articles, []
  set :app_file, __FILE__
  
  Dir.glob "#{root}/articles/*.md" do |file|
    # parse meta data and content from file
    meta, content = File.read(file).split("\n\n",2);
    # generate a metadata object
    article = OpenStruct.new YAML.load(meta)
    # convert the date to a time object
    article.date = Time.parse article.date.to_s
    # add the content
    article.content = content
    # generate a slug fro the url
    article.slug = File.basename(file, '.md')
    get "/#{article.slug}" do
      erb :post, :locals => { :article => article }
    end
    articles << article
  end

  articles.sort_by! { |article| article.date }
  articles.reverse!

  get('/') { erb :index }

end
