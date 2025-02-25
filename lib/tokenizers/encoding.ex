defmodule Tokenizers.Encoding do
  @moduledoc """
  The struct and associated functions for an encoding, the output of a tokenizer.

  Use these functions to retrieve the inputs needed for a natural language processing machine learning model.
  """

  @type t :: %__MODULE__{resource: binary(), reference: reference()}
  defstruct resource: nil, reference: nil

  alias Tokenizers.Native
  alias Tokenizers.Shared

  @doc """
  Get the tokens from an encoding.
  """
  @spec get_tokens(t()) :: [binary()]
  def get_tokens(encoding), do: encoding |> Native.get_tokens() |> Shared.unwrap()

  @doc """
  Get the ids from an encoding.
  """
  @spec get_ids(t()) :: [integer()]
  def get_ids(encoding), do: encoding |> Native.get_ids() |> Shared.unwrap()

  @doc """
  Same as `get_ids/1`, but returns binary with u32 values.
  """
  @spec get_u32_ids(t()) :: binary()
  def get_u32_ids(encoding), do: encoding |> Native.get_u32_ids() |> Shared.unwrap()

  @doc """
  Get the attention mask from an encoding.
  """
  @spec get_attention_mask(t()) :: [integer()]
  def get_attention_mask(encoding), do: encoding |> Native.get_attention_mask() |> Shared.unwrap()

  @doc """
  Same as `get_attention_mask/1`, but returns binary with u32 values.
  """
  @spec get_u32_attention_mask(t()) :: binary()
  def get_u32_attention_mask(encoding),
    do: encoding |> Native.get_u32_attention_mask() |> Shared.unwrap()

  @doc """
  Get token type ids from an encoding.
  """
  @spec get_type_ids(t()) :: [integer()]
  def get_type_ids(encoding), do: encoding |> Native.get_type_ids() |> Shared.unwrap()

  @doc """
  Same as `get_type_ids/1`, but returns binary with u32 values.
  """
  @spec get_u32_type_ids(t()) :: binary()
  def get_u32_type_ids(encoding),
    do: encoding |> Native.get_u32_type_ids() |> Shared.unwrap()

  @doc """
  Get special tokens mask from an encoding.
  """
  @spec get_special_tokens_mask(t()) :: [integer()]
  def get_special_tokens_mask(encoding),
    do: encoding |> Native.get_special_tokens_mask() |> Shared.unwrap()

  @doc """
  Same as `get_special_tokens_mask/1`, but returns binary with u32 values.
  """
  @spec get_u32_special_tokens_mask(t()) :: binary()
  def get_u32_special_tokens_mask(encoding),
    do: encoding |> Native.get_u32_special_tokens_mask() |> Shared.unwrap()

  @doc """
  Get offsets from an encoding.

  The offsets are expressed in terms of UTF-8 bytes.
  """
  @spec get_offsets(t()) :: [{integer(), integer()}]
  def get_offsets(encoding), do: encoding |> Native.get_offsets() |> Shared.unwrap()

  @doc """
  Truncate the encoding to the given length.

  ## Options
    * `direction` - The truncation direction. Can be `:right` or `:left`. Default: `:right`.
    * `stride` - The length of previous content to be included in each overflowing piece. Default: `0`.
  """
  @spec truncate(encoding :: t(), length :: integer(), opts :: Keyword.t()) ::
          t()
  def truncate(encoding, max_len, opts \\ []) do
    opts = Keyword.validate!(opts, direction: :right, stride: 0)
    encoding |> Native.truncate(max_len, opts[:stride], "#{opts[:direction]}") |> Shared.unwrap()
  end

  @doc """
  Pad the encoding to the given length.

  ## Options
    * `direction` - The padding direction. Can be `:right` or `:left`. Default: `:right`.
    * `pad_id` - The id corresponding to the padding token. Default: `0`.
    * `pad_token` - The padding token to use. Default: `"[PAD]"`.
    * `pad_type_id` - The type ID corresponding to the padding token. Default: `0`.
  """
  @spec pad(encoding :: t(), length :: pos_integer(), opts :: Keyword.t()) ::
          t()
  def pad(encoding, length, opts \\ []) do
    opts =
      Keyword.validate!(opts, direction: :right, pad_id: 0, pad_type_id: 0, pad_token: "[PAD]")

    encoding
    |> Native.pad(
      length,
      opts[:pad_id],
      opts[:pad_type_id],
      opts[:pad_token],
      "#{opts[:direction]}"
    )
    |> Shared.unwrap()
  end

  @doc """
  Returns the number of tokens in an `t()`.
  """
  @spec n_tokens(encoding :: t()) :: non_neg_integer()
  def n_tokens(encoding), do: encoding |> Native.n_tokens() |> Shared.unwrap()
end

defimpl Inspect, for: Tokenizers.Encoding do
  import Inspect.Algebra

  alias Tokenizers.Encoding

  def inspect(encoding, opts) do
    attrs = [
      n_tokens: Encoding.n_tokens(encoding),
      ids: Encoding.get_ids(encoding)
    ]

    concat(["#Tokenizers.Tokenizer<", to_doc(attrs, opts), ">"])
  end
end
