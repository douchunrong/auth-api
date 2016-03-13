shared_context 'database' do
  def clean_database_for_test(token: nil)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    post "/v1/test/database/clean"
  end

  # TODO
  def database_should_be_clean
    database_seed_should_be_loaded
  end

  # TODO
  def database_seed_should_be_loaded
  end
end
