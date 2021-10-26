defmodule M do
  # Para el formateo usé la página https://elixirformatter.com/
  # Main, llama a función inicio
  def main do
    inicio()
  end

  # Inicio, a través de la terminal recibe inputs de value y opción a seguir para conformar listas
  def inicio do
    valor = IO.gets("Ingrese value: ") |> String.trim() |> String.to_integer()

    accion =
      IO.gets(
        "Si desea ingresar sus propias listas, ingrese 1. Si desea usar listas predeterminadas, ingrese 2: "
      )
      |> String.trim()

    if accion == "1" do
      accion_input_lists(valor)
    else
      accion_listas_predeterminadas(valor)
    end
  end

  # Opción 1, recibe input de listas separadas por comas (ejemplo: 1,2,3,4,5,6,7)
  def accion_input_lists(valor) do
    string_list_1 =
      IO.gets(
        "Para conformar list_1, ingrese números separados por una coma (ejemplo: 7,6,10,-1): "
      )
      |> String.trim()

    string_list_2 =
      IO.gets(
        "Para conformar list_2, ingrese números separados por una coma (ejemplo: 8,10,29,12): "
      )
      |> String.trim()

    list_1 = String.split(string_list_1, ",") |> Enum.map(&String.to_integer/1) |> Enum.sort()

    list_2 =
      String.split(string_list_2, ",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> Enum.reverse()

    get_nearest_sum(list_1, list_2, valor, [0, 0, 99999])
  end

  # Opción 2, listas predeterminadas
  def accion_listas_predeterminadas(valor) do
    list_1 = Enum.sort([7, 6, 10, -1])
    list_2 = Enum.sort([8, 10, 29, 12]) |> Enum.reverse()
    get_nearest_sum(list_1, list_2, valor, [0, 0, 99999])
  end

  def get_nearest_sum([head_1 | tail_1], [head_2 | tail_2], value, resultado) do
    # Enum.at(resultado, 2) es el número más pequeño entre la suma de algún par de valores menos el valor value
    # Si existe una diferencia más pequeña aún, entonces se debe cambiar parámetro resultado en próximas llamadas a la función
    if(abs(head_1 + head_2 - value) < Enum.at(resultado, 2)) do
      # En este if se decide qué lista se acortará, si la suma es más pequeña que value, entonces se debe avanzar desde la lista en orden ascendente (a un número más grande)
      # Si la suma es más grande que value, se avanza desde la lista en orden descendente (a un número más pequeño)
      if(head_1 + head_2 < value) do
        get_nearest_sum(tail_1, [head_2 | tail_2], value, [
          head_1,
          head_2,
          abs(head_1 + head_2 - value)
        ])
      else
        get_nearest_sum([head_1 | tail_1], tail_2, value, [
          head_1,
          head_2,
          abs(head_1 + head_2 - value)
        ])
      end

      # A este else debería entrar cuando la diferencia no es más pequeña, entonces el par de valores siendo evaluados no son mejores que otros anteriores
    else
      # Al igual que en if de arriba, se decide qué lista se acortará
      if(head_1 + head_2 < value) do
        get_nearest_sum(tail_1, [head_2 | tail_2], value, resultado)
      else
        get_nearest_sum([head_1 | tail_1], tail_2, value, resultado)
      end
    end
  end

  # Casos borde, cuando no se puede separar más en [head|tail] alguno o ambos arreglos.
  def get_nearest_sum([], [_ | _], _, resultado) do
    IO.puts("(#{Enum.at(resultado, 0)}, #{Enum.at(resultado, 1)})")
  end

  def get_nearest_sum([_ | _], [], _, resultado) do
    IO.puts("(#{Enum.at(resultado, 0)}, #{Enum.at(resultado, 1)})")
  end

  def get_nearest_sum([], [], _, resultado) do
    IO.puts("(#{Enum.at(resultado, 0)}, #{Enum.at(resultado, 1)})")
  end
end
