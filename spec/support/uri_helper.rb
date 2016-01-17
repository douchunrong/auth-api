module UriHelper
  def self.fetch_params_from_uri(uri_str)
    query = self.uri_to_hash(uri_str)[:query]
    URI::decode_www_form(query).to_h
  end

  def self.uri_to_hash(uri_str)
    uri = URI.parse uri_str
    comp = uri.component
    Hash[comp.zip(uri.select(*comp))]
  end    
end
