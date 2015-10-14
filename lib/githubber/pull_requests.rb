module Githubber
  class PullRequests
    include HTTParty
    base_uri "https://api.github.com"

    def initialize(auth_token)
      @auth = {
        "Authorization" => "token #{auth_token}",
        "Accept"        => "application/vnd.github.v3.text-match+json",
        "User-Agent"    => "HTTParty"
      }
    end

    def list_pulls(owner, repo)
      PullRequests.get("/repos/#{owner}/#{repo}/pulls", :headers => @auth)
    end

    def update_user(options={})
      PullRequests.patch("/user", :headers => @auth, :body => options.to_json)
    end

    def code_search(query)
      response = PullRequests.get("/search/code", headers: @auth, query: { q: query } )
      response["items"].each do |item|
        item["text_matches"].each do |match|
          puts "Found a match! ... " + match["fragment"]
        end
      end
    end
  end
end
