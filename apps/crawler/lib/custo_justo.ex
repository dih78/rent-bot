defmodule Crawler.CustoJusto do
  def import(page \\ 1) do
    url = "https://www.gumtree.pl/s-mieszkania-i-domy-do-wynajecia/mokotow/v1c9008l3200012p1?pr=1000,2300"

    url
    |> get_page_html()
    |> get_dom_elements()
    |> extract_metadata()
  end

  defp get_page_html(url) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, [], follow_redirect: true)
    :iconv.convert("iso-8859-1", "utf-8", body)
    Logger.info(body)
  end

  defp get_dom_elements(body) do
    Floki.find(body, ".tileV1 > a")
  end

  defp extract_metadata(elements) do
    Enum.map(elements, fn {"a", attrs, content} ->
      %{
        title: title(content),
        url: url(attrs),
        price: price(content),
        image: image(content),
        provider: "Gumtree"
      }
    end)
  end

  defp url(link_attrs) do
    {"href", url} = List.keyfind(link_attrs, "href", 0)
    url
  end

  defp title(list_html) do
    [{"h2", _attrs, [title]}] = list_html |> Floki.find("h2")
    String.trim(title)
  end

  defp price(list_html) do
    [{"h5", _attrs, price}] = list_html |> Floki.find("h5")
    price |> List.last() |> String.trim()
  end

  defp image(html) do
    [{"img", attrs, _content}] = Floki.find(html, "div.imglist > img")
    case List.keyfind(attrs, "src", 0) do
      nil ->
        case List.keyfind(attrs, "data-src", 0) do
          nil -> ""
          {"data-src", url} -> url
        end
      {"src", url} ->
        url
    end
  end
end
