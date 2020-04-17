class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    # 会話に紐づくメッセージを取得する
    @messages = @conversation.messages
    # メッセージの数が10件より多ければ、10より多いフラグをtrueにし、メッセージを最新の10件に絞る
    if @messages.length > 10
      @over_ten = true
      @messages = Message.where(id: @messages[-10..-1].pluck(:id))
    end
    # メッセージの数が10件より少なければ、10より多いフラグをfalseにし、すべてのメッセージを取得する
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    # 最後にメッセージが存在し、かつユーザIDが自分（ログインユーザ）でなければ、今映っているメッセージを全て既読にする
    if @messages.last
      @messages.where.not(user_id: current_user.id).update_all(read: true)
    end
    # 表示するメッセージを作成日時順に並び替える
    @messages = @messages.order(:created_at)
    # 新規投稿のメッセージ用の変数を作成する
    @message = @conversation.messages.build
  end

  def create
    # 送られてきたparamsの値を利用して会話に紐づくメッセージを生成
    @message = @conversation.messages.build(message_params)
    # 保存ができれば、会話に紐づくメッセージの一覧を表示する
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
