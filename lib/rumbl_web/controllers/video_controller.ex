defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Video


  def action(conn ,_) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn),args)
  end

  def index(conn, _params, current_user) do
    videos = Multimedia.list_user_videos(current_user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, current_user) do
    changeset = Multimedia.change_video(current_user, %Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, current_user, %{"video" => video_params}) do
    case Multimedia.create_video(current_user, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, current_user, %{"id" => id}) do
    video = Multimedia.get_user_video!(current_user, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn,current_user, %{"id" => id}) do
    video = Multimedia.get_user_video!(current_user, id)
    changeset = Multimedia.change_video(current_user, video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, current_user, %{"id" => id, "video" => video_params}) do
    video = Multimedia.get_user_video!(current_user, id)

    case Multimedia.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(id,current_user)
    {:ok, _video} = Multimedia.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end
end
