require 'grouper-rest-client'
require "delegate"

module Ddr
  module Auth
    class GrouperGateway < SimpleDelegator

      SUBJECT_ID_RE = Regexp.new('[^@]+(?=@duke\.edu)')
      DEFAULT_TIMEOUT = 5

      def self.repository_groups(*args)
        new.repository_groups(*args)
      end

      def self.user_groups(*args)
        new.user_groups(*args)
      end
      
      def initialize
        super Grouper::Rest::Client::Resource.new(ENV["GROUPER_URL"],
                                                  user: ENV["GROUPER_USER"],
                                                  password: ENV["GROUPER_PASSWORD"],
                                                  timeout: ENV.fetch("GROUPER_TIMEOUT", DEFAULT_TIMEOUT).to_i)
      end

      # List of all grouper groups for the repository
      def repository_groups(raw = false)
        repo_groups = groups(REPOSITORY_GROUP_FILTER)
        if ok?
          return repo_groups if raw
          repo_groups.map do |g|
            Group.new(g["name"], label: g["displayExtension"])
          end
        else
          []
        end
      end

      def user_groups(user, raw = false)
        groups = []
        subject_id = user.principal_name.scan(SUBJECT_ID_RE).first
        return groups unless subject_id
        begin
          request_body = {
            "WsRestGetGroupsRequest" => {
              "subjectLookups" => [{"subjectIdentifier" => subject_id}]
            }
          }
          # Have to use :call b/c grouper-rest-client :subjects method doesn't support POST
          response = call("subjects", :post, request_body)
          if ok?
            result = response["WsGetGroupsResults"]["results"].first
            # Have to manually filter results b/c Grouper WS version 1.5 does not support filter parameter
            if result && result["wsGroups"]
              groups = result["wsGroups"].select { |g| g["name"] =~ /^#{REPOSITORY_GROUP_FILTER}/ }
            end
          end
        rescue StandardError => e
          # XXX Should we raise a custom exception?
          Rails.logger.error e
        end
        return groups if raw
        groups.map do |g|
          Group.new(g["name"], label: g["displayExtension"])
        end
      end

    end
  end
end
