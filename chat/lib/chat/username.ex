defmodule Chat.Username do
  @doc """
  Normalizes an username.

  This is useful because it allows to normalize a username and ignore upcase, downcase,
  and so on.
  """
  def normalize(username) when is_binary(username) do
    String.downcase(username)
  end
end
