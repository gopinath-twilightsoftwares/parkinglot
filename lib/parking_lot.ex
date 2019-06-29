defmodule ParkingLot do
  @moduledoc """
  Documentation for Parking.
  """

  def main(slots) do
    input = get_input()   
    parse(slots, input)
  end

  def parse(slots, input) do
      cond do

          length(input) == 1 ->
            [command] = input
            cond do
              command == "status" ->
                status(slots)
              command == "exit" or "Exit" ->
                System.halt()
              true ->
                IO.puts("Invalid Input")
                ParkingLot.main(slots)
            end
    
          length(input) == 2 ->
            [command, value] = input
            cond do
              command == "create_parking_lot" ->
                  slots = create(value)
                  slots = slots
                if length(slots) > 0 do
                  ParkingLot.main(convert_with_counter(slots))
                end
              command == "leave" ->
                leave(slots, value)
              command == "registration_numbers_for_cars_with_colour" ->
                registration_numbers_for_cars_with_colour(slots, value)
              command == "slot_numbers_for_cars_with_colour" ->
                slot_numbers_for_cars_with_colour(slots, value)
              command == "slot_number_for_registration_number" ->
                slot_number_for_registration_number(slots, value)
              true ->
                IO.puts("Invalid Input")
                ParkingLot.main(slots)
            end
    
          length(input) == 3 ->
            [command, value1, value2] = input
            cond do
              command == "park" ->
                park(slots, value1, value2)
              true ->
                IO.puts("Invalid Input")
                ParkingLot.main(slots)
            end
    
          true ->
            IO.puts("Invalid")
            ParkingLot.main(slots)
        end
  end

  def get_input() do
    IO.gets("Input: \n")
    |> String.split
  end

  def create(value) do
    {num, ""} = Integer.parse(value)
    IO.puts("Created a parking lot with #{num} slots")
    list = Enum.to_list 1..num
    Enum.map(list, fn _ -> %{color: "", parking_no: 0, reg_num: ""} end)
  end

  def park(slots, reg_no, colour) do
    # IO.inspect colour
    empty_slots = Enum.filter(slots, fn {x, _} -> x.parking_no == 0 end)
    cond do
      length(empty_slots) > 0 ->
        # IO.inspect empty_slots
        empty_slot = Enum.uniq_by(empty_slots, fn {x, _} -> x.parking_no end)
        # IO.inspect empty_slot
        for {_, y} <- empty_slot do
          slots = List.update_at(slots, y-1, fn {_, _} -> {%{color: colour, parking_no: y, reg_num: reg_no}, y} end)
          IO.puts("Allocated slot number: #{y}")
          ParkingLot.main(slots)
        end
      true ->
        IO.puts("Sorry, parking lot is full")
        ParkingLot.main(slots)
    end

    end

  def leave(slots, value) do
    # slots = convert_with_counter(slots)
    if slots != "" do
    {slot, ""} = Integer.parse(value)
    for {_, y} <- slots do
      if y == slot-1 do
          slots = List.update_at(slots, slot-1, fn {_, _} -> {%{color: "", parking_no: 0, reg_num: ""}, slot} end)
        IO.puts("Slot number #{slot} is free")          
      end
    end
  else
      IO.puts("Slots not created")        
  end
  ParkingLot.main(slots)
  end

  def status(slots) do      
      if slots != "" do
      IO.puts("Slot No.   Registration No   Color")
      for {x, y} <- slots do
            if x.reg_num != "" do
            IO.puts("#{y}       #{x.reg_num}   #{x.color}")
            end
         end
        else
            IO.puts("Slots not created")  
        end        
        ParkingLot.main(slots)
  end

  def registration_numbers_for_cars_with_colour(slots, color) do
      result = Enum.filter(slots, fn {x, _} -> x.color == color end)
      if length(result) > 0 do
         for {x, _} <- result do
          IO.puts("Allocated slot number: #{x.reg_num}")
         end
      else
        IO.puts("Not Found")
      end
  
      ParkingLot.main(slots)
  end

  def slot_numbers_for_cars_with_colour(slots, color) do
      result = Enum.filter(slots, fn {x, _} -> x.color == color end)
      if length(result) > 0 do
         for {x, _} <- result do
          IO.puts(x.parking_no)
         end
      else
        IO.puts("Not Found")
      end
      ParkingLot.main(slots)
  end

  def slot_number_for_registration_number(slots, value) do
      result = Enum.filter(slots, fn {x, _} -> x.reg_num == value end)
      if length(result) > 0 do
         for {x, _} <- result do
          IO.puts(x.parking_no)
         end
      else
        IO.puts("Not Found")
      end
      ParkingLot.main(slots)
  end

  def convert_with_counter(slots) do
    Enum.with_index(slots, 1)
  end

end
