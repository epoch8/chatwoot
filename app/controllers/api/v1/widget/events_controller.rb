class Api::V1::Widget::EventsController < Api::V1::Widget::BaseController
  include Events::Types

  def create
    Rails.configuration.dispatcher.dispatch(permitted_params[:name], Time.zone.now, contact_inbox: @contact_inbox,
                                                                                    event_info: permitted_params[:event_info].to_h.merge(event_info))
    head :no_content
  end

  private

  def event_info
    {
      pre_chat_form_enabled: @web_widget.pre_chat_form_enabled,
      widget_language: params[:locale],
      browser_language: browser.accept_language.first&.code,
      browser: browser_params,
      start_message: @web_widget.start_message
    }
  end

  def permitted_params
    params.permit(:name, :website_token, event_info: {})
  end
end
