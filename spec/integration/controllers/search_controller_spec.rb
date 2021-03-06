require_relative '../../rails_helper'

RSpec.describe SearchController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(SearchController).to receive(:app_insights_request_id) { 123456 }
    end

    context 'navigating to the search page' do
      it 'renders expected JSON output' do
        get '/search'

        expected_json = get_fixture('index', 'search')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end

    context 'with a query' do
      it 'renders expected JSON output' do
        get '/search?q=hello'

        expected_json = get_fixture('index', 'with_a_query')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'for the second page' do
        get '/search?count=10&q=diane+abbott&start_index=11'

        expected_json = get_fixture('index', 'second_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'for the last page' do
        get '/search?count=10&q=diane+abbott&start_index=7471'

        expected_json = get_fixture('index', 'last_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'with an empty query' do
        get '/search?q='

        expected_json = get_fixture('index', 'empty_query')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'when there are no results' do
        get '/search?q=dfgdfh89rhosiubreoweh'

        expected_json = get_fixture('index', 'no_results')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end

    context 'for a query with 8 pages of results' do
      it 'for the first page' do
        get '/search?q=linux'

        expected_json = get_fixture('index', 'linux_first_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'for the last page' do
        get '/search?count=10&q=linux&start_index=31'

        expected_json = get_fixture('index', 'linux_last_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end

    context 'when the start index is greater than the total number of pages' do
      it 'shows proper pagination' do
        get '/search?count=100&q=test&start_index=70100'

        expected_json = get_fixture('index', 'edgecase')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end
end
