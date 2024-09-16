require 'rails_helper'

RSpec.describe EnrollStaticMembersJob, type: :job do
  subject(:perform_job) do
    allow(service).to receive_messages call: nil, reports: nil
    described_class.perform_now(service)
  end

  let(:service) { instance_double(StaticMembersRecruiter) }

  it 'calls the given service' do
    perform_job
    expect(service).to have_received :call
  end

  it 'broadcasts the service result through websocket' do
    allow(ActionCable.server).to receive :broadcast

    perform_job

    expect(ActionCable.server).to have_received(:broadcast)
      .with('notifications', hash_including(:reports))
  end
end
