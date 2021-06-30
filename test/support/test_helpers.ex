defmodule Rumbl.TestHelpers do
    alias Rumbl.{Accounts, Multimedia}

    def user_fixtures(attrs \\ %{}) do
        username = "user#{System.unique_integer([:positive])}"
        {:ok, user} =
        attrs
        |> Enum.into(%{name: "Some USer", username: username,
        credential: %{email: attrs[:email] || "#{username}@exampe.com",
        password: attrs[:password] || "supersecret",}})
        |> Accounts.register_user()
     user
    end

    def video_fixtures(%Accounts.User{} = user, attrs \\ %{}) do
        attrs =
        Enum.into(attrs, %{title: "A Title",
        url: "http://example.com",
        description: "a description"})

        {:ok, video} = Multimedia.create_video(user, attrs)

        video
    end
end