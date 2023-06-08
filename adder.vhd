library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port (
        A, B  : in  std_logic_vector(3 downto 0);
        sum   : out std_logic_vector(3 downto 0);
        carry : out std_logic
        );
end entity adder;

architecture Behavioral of adder is
begin
    process(A, B)
        variable temp_sum   : unsigned(3 downto 0);
        variable temp_carry : std_logic;
    begin
        temp_sum   := unsigned(A) + unsigned(B);
        temp_carry := '0';

        if temp_sum(3) /= (A(3) xor B(3)) then
            temp_carry := '1';
        end if;

        sum   <= std_logic_vector(temp_sum);
        carry <= temp_carry;
        
    end process;
end architecture Behavioral;
