module FGraph
  module Rails
    module FGraphTagHelper
      def fgraph_javascript_include_tag
        %{<script src="http://connect.facebook.net/en_US/all.js"></script>}
      end
      
      # Inititalize XFBML Javascript include and initialization script.
      #
      # ==== Options
      # * <tt>app_id</tt> - overrride Fgraph.config['app_id'] value.
      # * <tt>async</tt> - asynchronous javascript include & initialization.
      #   for other Facebook JS initialization codes please wrap under:
      # * <tt>status</tt> - default: false, will check login status, and auto-login user if they are connected
      # * <tt>cookie</tt> - default: true, auto set cookies
      # * <tt>xfbml</tt> - default: true, auto parse xfbml tags
      # 
      # If async is set to true, the callback function is window.afterFbAsyncInit, e.g.
      #   window.afterFbAsyncInit = function() {
      #       ....
      #   }
      #
      def fgraph_javascript_init_tag(options={})
        options = { :app_id => FGraph.config['app_id'], 
          :status => true,
          :cookie => true,
          :xfbml => true
        }.merge(options || {})
        
        fb_init = "FB.init({appId: '#{options[:app_id]}', status: #{options[:status]}, cookie: #{options[:cookie]}, xfbml: #{options[:xfbml]}});"
        
        if options[:async]
          %{
            <div id="fb-root"></div>
            <script>
              window.fbAsyncInit = function() {
                #{fb_init}
                
                if (window.afterFbAsyncInit) {
                  window.afterFbAsyncInit();
                }
              };
              
              (function(d) {
                var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
                js = d.createElement('script'); js.id = id; js.async = true;
                js.src = "//connect.facebook.net/en_US/all.js";
                d.getElementsByTagName('head')[0].appendChild(js);
              }(document));
            </script>
          }
        else
          tag = fgraph_javascript_include_tag
          tag << %{
            <div id="fb-root"></div>
            <script>
              #{fb_init}
            </script>
          }
        end
      end

      def fgraph_image_tag(id, type=nil, options={})
        default_options = fgraph_image_options(type)
        default_options[:alt] = id['name'] if id.is_a?(Hash)
        image_tag(fgraph_picture_url(id, type), default_options.merge(options || {}))
      end
      
      def fgraph_image_options(type)
        case type
          when 'square'
            {:width => 50, :height => 50}
          when 'small'
            {:width => 50}
          when 'normal'
            {:width => 100}
          when 'large'
            {:width => 200}
          else
            {:width => 50, :height => 50}
        end
      end
    end 
  end
end