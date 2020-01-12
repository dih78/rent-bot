defmodule Crawler.Idealista do
  def import(page \\ 1) do
    url = "https://www.olx.pl/nieruchomosci/mieszkania/wynajem/warszawa/?search%5Border%5D=filter_float_price%3Aasc&search%5Bfilter_float_price%3Afrom%5D=1000&search%5Bfilter_float_price%3Ato%5D=2300&view=gallery#{page}"

    url
    |> get_page_html()
    |> get_dom_elements()
    |> extract_metadata()
  end

  defp get_page_html(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, [], follow_redirect: true)
    body
  end

  defp get_dom_elements(body) do
<<<<<<< HEAD
    Floki.find(body, ".space rel > article")
=======
    Floki.find(body, "div.items-container > article")
>>>>>>> parent of 888773b... parser
  end

  defp extract_metadata(elements) do
    elements
    |> Enum.filter(fn {"article", attrs, _content} ->
      attrs == []
    end)
    |> Enum.map(fn {"article", _attrs, content} ->
      %{
        title: title(content),
        url: url(content),
        price: price(content),
        image: image(content),
        provider: "Idealista"
      }
    end)
  end

  defp title(html) do
    [{"a", _attrs, [title]}] = Floki.find(html, "div.item-info-container > a.item-link")
    String.trim(title)
  end

  defp url(html) do
    [{"a", attrs, _content}] = Floki.find(html, "div.item-info-container > a.item-link")
    {"href", relative_url} = List.keyfind(attrs, "href", 0)
    "https://www.idealista.pt" <> relative_url
  end

  defp price(html) do
    [{"span", _, [price, {"span", _, [price_string]}]}] = Floki.find(html, "div.item-info-container > div.price-row > span.item-price")
    price <> price_string
  end

  defp image(html) do
    case Floki.find(html, "div.gallery-fallback > img") do
      [] -> ""
      [{"img", attrs, _content}] ->
        {"data-ondemand-img", url} = List.keyfind(attrs, "data-ondemand-img", 0)
        url
    end
  end
end
