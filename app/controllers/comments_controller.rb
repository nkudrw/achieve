class CommentsController < ApplicationController
    # コメントを保存、投稿するためのアクションです。
     def create
       # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを使用します。
       @comment = current_user.comments.build(comment_params)
       @blog = @comment.blog
       @notification = @comment.notifications.build(user_id: @blog.user.id )

       # クライアント要求に応じてフォーマットを変更
       # respond_toは、クライアントからの要求に応じてレスポンスのフォーマットを変更します。
    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました。' }
        format.json { render :show, status: :created, location: @comment }
        # JS形式でレスポンスを返します。
        format.js { render :index }

        unless @comment.blog.user_id == current_user.id
          Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'comment_created', {
            message: 'あなたの作成したブログにコメントが付きました'
          })
        end
        Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'notification_created', {
                  uncreate_count: Notification.where(user_id: @comment.blog.user.id).count
                })
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


 def  destroy
     # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを使用します。
    #  @comment = current_user.comments.build(comment_params)
    @comment=Comment.find(params[:id])
     @blog = @comment.blog
     # クライアント要求に応じてフォーマットを変更
     # respond_toは、クライアントからの要求に応じてレスポンスのフォーマットを変更します。
  respond_to do |format|
   if  @comment.destroy
     format.html { redirect_to blog_path(@blog), notice: 'コメントを削除しました。' }
     format.json { render :show, status: :destoroyed, location: @comment }
     # JS形式でレスポンスを返します。
     format.js { render :index }
   else
     format.html { render :new }
     format.json { render json: @comment.errors, status: :unprocessable_entity }
   end
 end
 end

     private
       # ストロングパラメーター
       def  comment_params
         params.require(:comment).permit(:blog_id, :content)
       end
   end
