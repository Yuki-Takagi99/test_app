class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.all
  end

  def create
    if logged_in?
      # 該当ユーザ間で過去に会話が発生しているか確認
      if Conversation.between(params[:sender_id], params[:recipient_id]).present?
        # 発生していた場合、その会話情報をインスタンス変数@conversationに代入
        @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      else
        # 過去に会話が発生していなかった場合、強制的に会話情報(チャットルーム)を生成
        @conversation = Conversation.create!(conversation_params)
      end
      # いずれの状態であっても生成されたメッセージの一覧画面に移動させる
      redirect_to conversation_messages_path(@conversation)
    else
      redirect_to root_path
    end
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
