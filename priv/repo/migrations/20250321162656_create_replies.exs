defmodule Slax.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :body, :text, null: false
      add :message_id, references(:messages, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:replies, [:message_id])
    create index(:replies, [:user_id])
  end
end
