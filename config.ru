#rackup -E production -D -s thin

$LOAD_PATH.unshift 'lib'

require 'rack/cache'
use Rack::Cache

require 'blog'
run Blog
