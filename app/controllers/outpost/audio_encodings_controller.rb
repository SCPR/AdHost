class Outpost::AudioEncodingsController < Outpost::BaseController
  def destroy
    @preroll_campaign = PrerollCampaign.find(params[:preroll_campaign_id])
    @audio_encoding   = AudioEncoding.find(params[:id])

    @audio_encoding.destroy

    flash[:notice] = "Deleted Audio Encoding for #{@audio_encoding.stream_key}"
    redirect_to @preroll_campaign.admin_edit_path and return
  end
end
