class LimitsAndIndexes < ActiveRecord::Migration
  def self.up
      # users
      change_column :users, :username, :string, {:null => false}
      change_column :users, :email, :string, {:null => false}
      change_column :users, :privileges, :integer, {:null => false, :default => 0}

      add_index :users, :username, {:name => "users_username_idx", :unique => true}
      add_index :users, :email, {:name => "users_email_idx", :unique => true}


      # cameras
      change_column :cameras, :owner, :integer, {:null => false}
      change_column :cameras, :type, :integer, {:limit => 1, :null => false}
      change_column :cameras, :test_camera, :boolean, {:default => 0, :null => false}
      change_column :cameras, :licence, :string, {:null => false}
      change_column :cameras, :watermark, :boolean, {:default => 0, :null => false}

      add_index :cameras, :owner, {:name => "cameras_owner_idx", :unique => false}
      add_index :cameras, :test_camera, {:name => "cameras_testcamera_idx", :unique => false}

      # cameras_tags
      change_column :cameras_tags, :camera_id, :integer, {:null => false}
      change_column :cameras_tags, :tag_id, :integer, {:null => false}

      add_index :cameras_tags, [:camera_id, :tag_id], {:name => "camerastags_ids_idx", :unique => true}

      # cameras_events
      change_column :cameras_events, :camera_id, :integer, {:null => false}
      change_column :cameras_events, :event_id, :integer, {:null => false}

      add_index :cameras_events, [:camera_id, :event_id], {:name => "camerasevents_ids_idx", :unique => true}

      # camera_tags
      change_column :camera_tags, :tag, :string, {:null => false} 

      add_index :camera_tags, :tag, {:name => "cameratags_tag_idx", :unique => false}
      add_index :camera_tags, :parent, {:name => "cameratags_parent_idx", :unique => false}

      # events
      change_column :events, :name, :string, {:null => false}
      change_column :events, :description, :text, {:null => false}
      change_column :events, :start_date, :date, {:null => false}

      add_index :events, :start_date, {:name => "events_startdate_idx", :unique => false}
      add_index :events, :end_date, {:name => "events_enddate_idx", :unique => false}

      # event_tags
      change_column :event_tags, :tag, :string, {:null => false}

      add_index :event_tags, :tag, {:name => "eventtags_tag_idx", :unique => false}
      add_index :event_tags, :tag, {:name => "eventtags_parent_idx", :unique => false}

      # events_tags
      change_column :events_tags, :event_id, :integer, {:null => false}
      change_column :events_tags, :tag_id, :integer, {:null => false}

      add_index :events_tags, [:event_id, :tag_id], {:name => "eventstags_ids_idx", :unique => true}

      # camera_details
      change_column :camera_details, :details_date, :date, {:null => false}
      change_column :camera_details, :longitude, :float, {:null => false}
      change_column :camera_details, :latitude, :float, {:null => false}
      change_column :camera_details, :bearing, :integer, {:null => false}
      change_column :camera_details, :resolution_x, :integer, {:null => false}
      change_column :camera_details, :resolution_y, :integer, {:null => false}

      add_index :camera_details, :details_date, {:name => "cameradetails_detailsdate_idx", :unique => false}
      add_index :camera_details, :longitude, {:name => "cameradetails_longitude_idx", :unique => false}
      add_index :camera_details, :latitude, {:name => "cameradetails_latitude_idx", :unique => false}

      # weather_codes
      change_column :weather_codes, :condition, :string, {:null => false}

      # images
      # Note that image_present is changed to a boolean
      change_column :images, :camera_id, :integer, {:null => false}
      change_column :images, :date, :date, {:null => false}
      change_column :images, :image_present, :boolean, {:null => false}
      
      add_index :images, [:camera_id, :date], {:name => "image_camid-date_idx", :unique => true}
      add_index :images, :date, {:name => "image_date_idx", :unique => false}
      add_index :images, :image_present, {:name => "image_imagepresent_idx", :unique => false}

      # messages
      # Note that read_by_user, read_by_admin and resolved are changed to boolean
      change_column :messages, :camera_id, :integer, {:null => false}
      change_column :messages, :timestamp, :datetime, {:null => false}
      change_column :messages, :message_type, :integer, {:null => false}
      change_column :messages, :read_by_user, :boolean, {:null => false, :default => 0}
      change_column :messages, :read_by_admin, :boolean, {:null => false, :default => 0}
      change_column :messages, :resolved, :boolean, {:null => false, :default => 0}

      add_index :messages, :camera_id, {:name => "messages_cameraid_idx", :unique => false}
      add_index :messages, :message_type, {:name => "messages_messagetype_idx", :uniqie => false}
      add_index :messages, :read_by_user, {:name => "messages_readbyuser_idx", :unique => false}
      add_index :messages, :read_by_admin, {:name => "messages_readbyadmin_idx", :unique => false}

      # message_types
      change_column :message_types, :subject, :string, {:null => false}
      change_column :message_types, :text, :text, {:null => false}





  end

  def self.down
      # users
      change_column :users, :username, :string, {:null => true}
      change_column :users, :email, :string, {:null => true}
      change_column :users, :privileges, :string, {:null => true, :default => nil}

      remove_index :users, :users_username_idx
      remove_index :users, :users_email_idx

      # cameras
      change_column :cameras, :owner, :integer, {:null => true}
      change_column :cameras, :type, :integer, {:limit => 1, :null => true}
      change_column :cameras, :test_camera, :integer, {:default => nil, :null => true}
      change_column :cameras, :licence, :string, {:null => true}
      change_column :cameras, :watermark, :integer, {:limit => 1, :null => true}

      remove_index :cameras, :cameras_owner_idx
      remove_index :cameras, :cameras_testcamera_idx

      # cameras_tags
      change_column :cameras_tags, :camera_id, :integer, {:null => true}
      change_column :cameras_tags, :tag_id, :integer, {:null => true}

      remove_index :cameras_tags, :camerastags_ids_idx 

      # cameras_events
      change_column :cameras_events, :camera_id, :integer, {:null => true}
      change_column :cameras_events, :event_id, :integer, {:null => true}

      remove_index :cameras_events, :cameras_events_ids_idx

      # camera_tags
      change_column :camera_tags, :tag, :string, {:null => true}
      
      remove_index :camera_tags, :cameratag_tag_idx
      remove_index :camera_tags, :cameratag_parent_idx

      # events
      change_column :events, :name, :string, {:null => true}
      change_column :events, :description, :text, {:null => true}
      change_column :events, :start_date, :date, {:null => true}

      remove_index :events, :events_startdate_idx
      remove_index :events, :events_enddate_idx

      # event_tags
      change_column :event_tags, :tag, :string, {:null => true}

      remove_index :event_tags, :eventtags_tag_idx
      remove_index :event_tags, :eventtags_parent_idx

      # events_tags
      change_column :events_tags, :event_id, :integer, {:null => true}
      change_column :events_tags, :tag_id, :integer, {:null => true}

      remove_index :events_tags, :eventstags_ids_idx

      # camera_details
      change_column :camera_details, :details_date, :date, {:null => true}
      change_column :camera_details, :longitude, :float, {:null => true}
      change_column :camera_details, :latitude, :float, {:null => true}
      change_column :camera_details, :bearing, :integer, {:null => true}
      change_column :camera_details, :resolution_x, :integer, {:null => true}
      change_column :camera_details, :resolution_y, :integer, {:null => true}

      remove_index :camera_details, :cameradetails_detailsdate_idx
      remove_index :camera_details, :cameradetails_longitude_idx
      remove_index :camera_details, :cameradetails_latitude_idx

      # weather_codes
      change_column :weather_codes, :condition, :string, {:null => true}

      # images
      change_column :images, :camera_id, :integer, {:null => true}
      change_column :images, :date, :date, {:null => true}
      change_column :images, :image_present, :integer, {:null => true, :limit => 1}

      remove_index :images, :image_camid-date_idx
      remove_index :images, :image_date_idx
      remove_index :images, :image_imagepresent_idx

      # messages
      change_column :messages, :camera_id, :integer, {:null => true}
      change_column :messages, :timestamp, :datetime, {:null => true}
      change_column :messages, :message_type, :integer, {:null => true}
      change_column :messages, :read_by_user, :integer, {:null => true, :limit => 1, :default => nil}
      change_column :messages, :read_by_admin, :integer, {:null => true, :limit => 1, :default => nil}
      change_column :messages, :resolved, :integer, {:null => true, :limit => 1, :default => nil}

      remove_index :messages, :messages_cameraid_idx
      remove_index :messages, :messages_messagetype_idx
      remove_index :messages, :messages_readbyuser_idx
      remove_index :messages, :messages_readbyadmin_idx

      # message_types
      change_column :message_types, :subject, :string, {:null => true}
      change_column :message_types, :text, :text, {:null => true}
  end
end
