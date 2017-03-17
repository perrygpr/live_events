# Playfirst Live Events
Backend for playfirst live events.

## Setup
1. Clone the repo locally
1. Setup development db credentials (default is a user pfle with no password connecting to db pfle on localhost)
1. Setup your preferred ruby version manager (RVM or rbenv; rbenv already has a .ruby-version checked in so it should just prompt you to install it)
1. Run ```bundle install```
1. Setup the database:
    * ```bundle exec rake db:setup```
    * Alternatively if you don't want to seed the db:
    
    ```
    bundle exec rake db:create
    bundle exec rake db:migrate
    ```
    * The database setup step is not needed for local builds if config/database.yml has Development pointed to an existing MySQL db
1. Install geographic IP file: ``bundle exec rake admin:download_geoip``
1. Start the server: ```bundle exec rails s```
1. Navigate to localhost:3000 -- Google rejects signin with raw IPs like 0.0.0.0:3000
1. Should be able to login with your playfirst google credentials
1. Example API call -- curl -X POST -d "" localhost:3000/api/register_for_pfid
1. Tests -- rake db:migrate && rake db:test:prepare --trace then rspec spec/lib/pfid_spec.rb

## Implementation
1. Event milestones and associated rewards are serialized, which means both take an array of values and store them in the db:
    ```
	1.9.3-p545 :001 > event = Event.new
	 => #<Event id: "73b44b2a2a114b348bb50317701ad14e", app_id: nil, name: nil, starts_at: nil, ends_at: nil, min_app_version: nil, min_asset_tag: nil, created_at: nil, updated_at: nil, platform_ios: false, platform_google: false, platform_amazon: false, notification_content_uid: nil, performance_throttle: 100, restrictions: nil, countries: nil, audited: false, milestones: nil, rewards: nil, eligiblesession: nil, eligiblelevel: nil, reappear: nil, durationactive: nil> 
	1.9.3-p545 :002 > event.milestones = ['3', '5', '8']
	 => ["3", "5", "8"] 
	1.9.3-p545 :003 > event.save
	   (29.0ms)  BEGIN
	  Event Exists (29.4ms)  SELECT 1 AS one FROM `events` WHERE `events`.`id` = BINARY '73b44b2a2a114b348bb50317701ad14e' LIMIT 1
	   (28.9ms)  ROLLBACK
	 => false 
	1.9.3-p545 :004 > event.milestones
	 => ["3", "5", "8"] 
    ```

## API

1.             api_connect GET      /api/connect(.:format)                 api/connect#index
1.                api_test GET      /api/test(.:format)                    api/test#index
1.		         test_exception GET      /test_exception(.:format)              application#test_exception
1.        api_update_score GET      /api/update_score(.:format)            api/update_score#index
    * required parameters ["app_id","app_version","language_code","device_type","os","os_version","install_id","vendor_id, android_id or advertising_id","app_id","event_id","player_id","name","value","milestones_attained"]
1.    api_view_leaderboard GET      /api/view_leaderboard(.:format)        api/view_leaderboard#index
1.       api_request_award GET      /api/request_award(.:format)           api/request_award#index
    * required parameters ["app_id","app_version","language_code","device_type","os","os_version","install_id","vendor_id, android_id or advertising_id","app_id","event_id","player_id","name","milestone","reward"]
1.       api_request_token GET      /api/request_token(.:format)           api/request_token#index
