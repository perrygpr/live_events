require 'base64'

module API
  
    # all PFID related in one controller to make it portable to its own server one day
    #class API::PfidController < API::ApplicationController
    class API::PfidController < API::PfidbaseController
      before_action :authenticate

      # a POST method because not safe or idempotent from server perspective
      def register_for_pfid
        logger.info "register for pfid"
      
        if params[:displayname] == 'testdisplayname'
          # curl -X POST -d "" localhost:3000/api/register_for_pfid?displayname=testdisplayname
          if Rails.env.development?
            #debugger
          end
        end
      
        response.headers["register_for_pfid"]="v1.0"

        # 204 no content, returns empty response body which is faster for the API than returning json
        # another way to say the below is -- render nothing: true, status: 204
        #head :no_content
        
        respond_to do |format|
          # 201 created
          format.json {render :json => {"status" =>  201}}
        end
      end
      
      def get_pfid
        logger.info "get pfid"
        
        # common practice is not to expose IDs to the public via your API because unsavory users
        # can guess IDs in the database and that might be a potential risk, however using GUIDs gets
        # us around that
        
        # with their GUID successive access to PF services is more efficent with less overhead identifying the customer
        
        if Rails.env.development?
          debugger
        end
        
        response.headers["get_pfid"]="v1.0"
        respond_to do |format|
          # 200 OK
          format.json {render :json => {"status" =>  200}}
        end
        
      end    
      
      protected
    
      def authenticate
      end
    
    end
  
end