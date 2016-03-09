class Server < ActiveRecord::Base
    # Certifica que so ha um server no banco
    validates :singleton_guard, presence: true, uniqueness: true, inclusion: {in: [true]}
    URL_REGEX = /\Ahttp(s)?:\/\/.+/i
    validates :repo_url, format: URL_REGEX

    def self.instance
        return find_by_singleton_guard(true)
    rescue ActiveRecord::RecordNotFound
        s = Server.new
        s.singleton_guard = true
        s.save!
        return s
    end

end
