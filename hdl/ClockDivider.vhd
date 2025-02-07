library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ClockDivider is
   generic (
      TPD_G          : time                  := 1 ns;
      RST_ASYNC_G    : boolean               := false;
      LEADING_EDGE_G : std_logic                    := '1';
      COUNT_WIDTH_G  : integer range 1 to 32 := 16);
   port (
      clk        : in  std_logic;
      rst        : in  std_logic;
      highCount  : in  std_logic_vector(COUNT_WIDTH_G-1 downto 0);
      lowCount   : in  std_logic_vector(COUNT_WIDTH_G-1 downto 0);
      delayCount : in  std_logic_vector(COUNT_WIDTH_G-1 downto 0);
      divClk     : out std_logic;
      preRise    : out std_logic;
      preFall    : out std_logic);
end entity ClockDivider;

architecture rtl of ClockDivider is

   type StateType is (DELAY_S, CLOCK_S);

   type RegType is record
      state   : StateType;
      divClk  : std_logic;
      preRise : std_logic;
      preFall : std_logic;
      counter : std_logic_vector(COUNT_WIDTH_G-1 downto 0);
   end record RegType;

   constant REG_INIT_C : RegType := (
      state   => DELAY_S,
      divClk  => not LEADING_EDGE_G,
      preRise => '0',
      preFall => '0',
      counter => (others => '0'));

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

begin

   comb : process (delayCount, highCount, lowCount, r, rst) is
      variable v : RegType;
   begin
      v := r;

      v.counter := r.counter + 1;
      v.preRise := '0';
      v.preFall := '0';

      case (r.state) is
         when DELAY_S =>
            if (r.counter = delayCount -1) then
               if (LEADING_EDGE_G = '1') then
                  v.preRise := '1';
               else
                  v.preFall := '1';
               end if;
            end if;
            if (r.counter = delayCount) then
               v.divClk  := LEADING_EDGE_G;
               v.state   := CLOCK_S;
               v.counter := (others => '0');
            end if;

         when CLOCK_S =>
            if (r.divClk = '1' and r.counter = highCount-1) then
               v.preFall := '1';
            end if;

            if (r.divClk = '0' and r.counter = lowCount-1) then
               v.preRise := '1';
            end if;

            if ((r.divClk = '1' and (r.counter = highCount)) or (r.divClk = '0' and (r.counter = lowCount))) then
               v.divClk  := not r.divClk;
               v.counter := (others => '0');
            end if;
      end case;

      if (RST_ASYNC_G = false and rst = '1') then
         v := REG_INIT_C;
      end if;

      rin <= v;

      divClk  <= r.divClk;
      preRise <= r.preRise;
      preFall <= r.preFall;
   end process comb;

   seq : process (clk, rst) is
   begin
      if (RST_ASYNC_G and rst = '1') then
         r <= REG_INIT_C after TPD_G;
      elsif rising_edge(clk) then
         r <= rin after TPD_G;
      end if;
   end process seq;

end architecture rtl;
