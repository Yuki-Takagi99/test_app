class CommentsController < ApplicationController
  # コメントを保存、投稿するためのアクション
  def create
    # Blogをパラメータの値から探し出し,Blogに紐づくcommentsとしてbuildする
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.build(comment_params)
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.js { render :index }
      else
        format.html { redirect_to blog_path(@blog), notice: '投稿できませんでした．．．' }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:blog_id, :content)
  end
end
