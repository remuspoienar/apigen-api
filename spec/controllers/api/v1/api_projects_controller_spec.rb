require 'rails_helper'

describe Api::V1::ApiProjectsController, type: :controller do

  let!(:api_user) { FactoryGirl.create(:api_user) }
  let!(:projects_count) { 5 }
  let!(:api_projects) { FactoryGirl.create_list(:api_project, projects_count, created_by: api_user) }
  let!(:auth_token) { AuthenticateUser.new(api_user.email, api_user.password).call }
  let!(:default_headers) { {'Content-Type' => 'application/json', 'Authorization' => auth_token} }

  describe 'GET #index' do

    subject { get :index }

    context 'with authenticated user' do
      before { request.headers.merge!(default_headers) }

      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns all api projects created by the user' do
        subject
        expect(json.count).to eq projects_count
      end
    end

    context 'without authenticated user' do
      it 'returns http unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #show' do
    let!(:api_project_id) { api_projects.first.id }

    subject { get :show, params: {id: api_project_id} }

    context 'with authenticated user' do
      before { request.headers.merge!(default_headers) }
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns the json representation of the api project' do
        subject
        expect(json[:id]).to eq api_project_id
      end
    end

    context 'without authenticated user' do
      it 'returns http unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end


  describe 'POST #create' do
    before { allow_any_instance_of(ApiProject).to receive(:generate_code) }
    subject { post :create, params: params }

    context 'with authenticated user' do
      before { request.headers.merge!(default_headers) }

      context 'with valid params' do
        let!(:params) { {name: 'new project'} }

        it 'returns http success' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'creates a new record' do
          subject
          expect(api_user.api_projects.last.name).to eq params[:name]
        end

        it 'returns empty json' do
          subject
          expect(json).to be_empty
        end
      end

      context 'without valid params' do
        let!(:params) { {} }

        it 'returns http unprocessable_entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns errors' do
          subject
          expect(json[:errors].inspect).to match /Name can't be blank/
        end
      end
    end

    context 'without authenticated user' do
      let!(:params) { {} }
      it 'returns http unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let!(:api_project_id) { api_projects.first.id }
    let!(:params) { {id: api_project_id} }

    before { allow_any_instance_of(ApiProject).to receive(:generate_code) }

    subject { put :update, params: params }

    context 'with authenticated user' do
      before { request.headers.merge!(default_headers) }

      context 'with valid params' do
        before { params[:name] = 'new name' }

        it 'returns http success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'returns empty json' do
          subject
          expect(json).to be_empty
        end

        it 'updates the name attribute' do
          subject
          expect(api_user.api_projects.find(api_project_id).name).to eq params[:name]
        end
      end

      context 'without valid params' do
        before { params[:name] = nil }

        it 'returns http unprocessable_entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns errors' do
          subject
          expect(json[:errors].inspect).to match /Name can't be blank/
        end
      end
    end

    context 'without authenticated user' do
      it 'returns http unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:api_project_id) { api_projects.first.id }

    subject { delete :destroy, params: {id: api_project_id} }

    context 'with authenticated user' do
      before { request.headers.merge!(default_headers) }

      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns empty json' do
        subject
        expect(json).to be_empty
      end

      it 'current user has one less api project' do
        subject
        expect(api_user.api_projects.count).to eq projects_count - 1
      end
    end

    context 'without authenticated user' do
      it 'returns http unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
