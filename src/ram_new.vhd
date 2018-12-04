-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.define.all;

entity ram_new is
    Port ( clk : in std_logic;
    rst : in std_logic;

    -- id
    ce_id : in  std_logic;
    addr_id : in  std_logic_vector (15 downto 0);
    inst_id : out  std_logic_vector (15 downto 0);
    inst_ready : out std_logic;
    rom_ready_o : out std_logic;

    --mem
    re_i : in  std_logic;
    we_i : in  std_logic;
    addr_i : in  std_logic_vector (15 downto 0);
    data_i : in  std_logic_vector (15 downto 0);
    data_o : out  std_logic_vector (15 downto 0);
    ram_ready_o : out std_logic;

    --ram1
    data_ready: in std_logic;
    tbre: in std_logic;
    tsre: in std_logic;
    ram1_addr: out std_logic_vector(17 downto 0);
    ram1_data: inout std_logic_vector(15 downto 0);
    ram1_oe: out std_logic;
    ram1_we: out std_logic;
    ram1_en: out std_logic;

    rdn: out std_logic;
    wrn: out std_logic;

    --ram2
    -- Ram2Addr: out std_logic_vector(17 downto 0);
    -- Ram2Data: inout std_logic_vector(15 downto 0);
    -- Ram2OE: out std_logic;
    -- Ram2WE: out std_logic;
    -- Ram2EN: out std_logic;

    --flash
    FlashByte: out std_logic;
    FlashVpen: out std_logic;
    FlashCE: out std_logic;
    FlashOE: out std_logic;
    FlashWE: out std_logic;
    FlashRP: out std_logic;
    FlashAddr: out std_logic_vector(22 downto 1);
    FlashData: inout std_logic_vector(15 downto 0);

    --vga
    -- VGAAddr: in std_logic_vector(17 downto 0);
    VGAData: out std_logic_vector(15 downto 0);
    VGAPos: out std_logic_vector(12 downto 0);
    VGAMEMWE: out std_logic_vector(0 downto 0)

    --PS2
    -- LED: out std_logic_vector(15 downto 0);
    -- keyboardASCII: in std_logic_vector(15 downto 0);
    -- keyboardOE : in std_logic
);
end ram_new;

architecture Behavioral of ram_new is
    -- constant InstNum : integer := 100;
    constant kernelInstNum : integer := 1000;
    constant fullInstNum : integer := 5000;


    -- type InstArray is array (0 to InstNum) of std_logic_vector(15 downto 0);
    -- signal insts: InstArray := (
    -- others => NopInst);
    signal clk_2,clk_4,clk_8: std_logic;
    signal FlashRead, FlashReset: std_logic;
    signal FlashDataOut: std_logic_vector(15 downto 0);
    signal FlashAddrIn : std_logic_vector(22 downto 1);
    -- signal LoadComplete: std_logic:= '1';
    signal LoadComplete: std_logic;
    signal i: std_logic_vector(18 downto 0);
    signal read_prep, write_prep: std_logic;
    -- signal Ram2OE_tmp: std_logic;
    signal rom_ready,ram_ctrl: std_logic;
    signal VGAPos_tmp: std_logic_vector(15 downto 0);
    -- signal hasReadASCII : std_logic;
    -- signal ASCIIout: std_logic_vector(15 downto 0);

    -- component flash
    --   port(clk: in std_logic;
    --        rst: in std_logic;
    --        addr_in: in std_logic_vector(22 downto 1);
    --
    --        flash_byte: out std_logic;
    --        flash_vpen: out std_logic;
    --        flash_ce: out std_logic;
    --        flash_oe: out std_logic;
    --        flash_we: out std_logic;
    --        flash_rp: out std_logic;
    --
    --        flash_addr: out std_logic_vector(22 downto 1);
    --        flash_data: inout std_logic_vector(15 downto 0)
    --        );
    -- end component;
    component flash_io
    Port ( addr : in  std_logic_vector (22 downto 1);
    data_out : out  std_logic_vector (15 downto 0);
    clk : in std_logic;
    reset : in std_logic;

    flash_byte : out std_logic;
    flash_vpen : out std_logic;
    flash_ce : out std_logic;
    flash_oe : out std_logic;
    flash_we : out std_logic;
    flash_rp : out std_logic;
    flash_addr : out std_logic_vector(22 downto 1);
    flash_data : inout std_logic_vector(15 downto 0);

    ctl_read : in  std_logic
    );
end component;

begin
    process(clk)	--����Ƶ
    begin

        if clk'event and clk='1' then
            clk_2 <= not clk_2;
        end if;
    end process;

    process(clk_2)
    begin
        if clk_2'event and clk_2='1' then
            clk_4 <= not clk_4;
        end if;
    end process;

    process(clk_4)
    begin
        if clk_4'event and clk_4='1' then
            clk_8 <= not clk_8;
        end if;
    end process;

    flash_io_component: flash_io port map(addr=>FlashAddrIn, data_out=>FlashDataOut, clk=>clk_8, reset=>FlashReset,
    flash_byte=>FlashByte, flash_vpen=>FlashVpen, flash_ce=>FlashCE, flash_oe=>FlashOE, flash_we=>FlashWE,
    flash_rp=>FlashRP, flash_addr=>FlashAddr, flash_data=>FlashData, ctl_read=>FlashRead);

    -- flash_component: flash port map(
    --   clk => clk_4,
    --   rst => FlashReset,
    --   addr_in => FlashAddrIn,
    --
    --   flash_byte=>FlashByte,
    --   flash_vpen=>FlashVpen,
    --   flash_ce=>FlashCE,
    --   flash_oe=>FlashOE,
    --   flash_we=>FlashWE,
    --   flash_rp=>FlashRP,
    --
    --   flash_addr=>FlashAddr,
    --   flash_data=>FlashData
    --   -- ctl_read=>FlashRead
    -- );
    -- hasRead_control: process(clk, re_i, addr_i, ASCIIout)
    -- begin
    --     if (clk'event and clk = '1') then
    --         if ((re_i = Enable) and (addr_i = x"bf06") and (ASCIIout /= x"0000")) then
    --             hasReadASCII <= Enable;
    --         else
    --             hasReadASCII <= Disable;
    --         end if;
    --     end if;
    -- end process;
    --
    -- display: process(keyboardASCII, keyboardOE, hasReadASCII)
    -- begin
    --     --		if (keyboardOE = Enable) then
    --     --			ASCIIout <= keyboardASCII;
    --     --			LED <= keyboardASCII;
    --     --		elsif (hasReadASCII = Enable) then
    --     --			ASCIIout <= (others => '0');
    --     --		end if;
    --     if (keyboardOE = Enable) then
    --         ASCIIout <= keyboardASCII;
    --         LED <= keyboardASCII;
    --     end if;
    -- end process;
    --
    VGAPos_control: process(clk, VGAPos_tmp, we_i)
    begin
        if (clk'event and clk = Enable and we_i = Enable) then
            VGAPos <= conv_std_logic_vector(conv_integer(VGAPos_tmp(12 downto 7)) * 80+conv_integer(VGAPos_tmp(6 downto 0)),13);
        end if;
    end process;


    inst_ready <= LoadComplete;

    ram_ready_o <= not(re_i and ram_ctrl);
    rom_ready_o <= rom_ready;

    ram_ctrl_state: process(clk,rst,we_i,re_i)
    begin
        if (rst = Enable) then
            ram_ctrl <= '1';
        else
            if (clk'event and clk = '1') then
                if (re_i = Enable) then
                    ram_ctrl <= not(ram_ctrl);
                else
                    ram_ctrl <= '1';
                end if;
            end if;
        end if;
    end process;

    Rom_ready_state: process(addr_i,we_i,re_i)
    begin
        if ((re_i = Enable) or (we_i = Enable)) then
            rom_ready <= '0';
        else
            rom_ready <= '1';
        end if;
    end process;

    Ram1WE_control: process(rst,clk,we_i,re_i,addr_i,LoadComplete,i)
    begin
        if ((rst = Enable) or (re_i = Enable) or (addr_i = x"bf00") or (addr_i = x"bf01") or (addr_i = x"bf04") or (addr_i = x"bf05")) then
            ram1_we <= '1';
        elsif (((LoadComplete = '1') and (we_i = Enable)) or ((LoadComplete = '0') and (i(18 downto 3) < kernelInstNum))) then
        -- elsif (((LoadComplete = '1') and (we_i = Enable)) or (LoadComplete = '0')) then
            ram1_we <= clk;
        else
            ram1_we <= '1';
        end if;
    end process;

    wrn_control: process(rst,clk,we_i,write_prep,LoadComplete)
    begin
        if ((LoadComplete = '0') or (rst = Enable) or (we_i = Disable)) then
            wrn <= '1';
        elsif (write_prep = Enable) then
            wrn <= clk;
        else
            wrn <= '1';
        end if;
    end process;

    rdn_control: process(rst,clk,re_i,read_prep,LoadComplete)
    begin
        if ((LoadComplete = '0') or (rst = Enable) or (re_i = Disable)) then
            rdn <= '1';
        elsif (read_prep = Enable) then
            rdn <= clk;
        else
            rdn <= '1';
        end if;
    end process;

    VGAWE_control: process(addr_i,we_i)
    begin
        if ((addr_i = x"bf04") and (we_i = Enable)) then
            VGAMEMWE <= "1";
        else
            VGAMEMWE <= "0";
        end if;
    end process;

    Ram1_control: process(rst, addr_i, addr_id, we_i, re_i, data_i, data_ready, tbre, tsre, LoadComplete, FlashDataOut, i)
    -- Ram1_control: process(rst, addr_i, addr_id, we_i, re_i, data_i, data_ready, tbre, tsre, LoadComplete, i)
    begin
        if (rst = Enable) then
            ram1_en <= '0';
            ram1_oe <= '1';
            ram1_addr <= (others => '0');
            ram1_data <= (others => 'Z');
            read_prep <= Disable;
            write_prep <= Disable;
        else
            if (LoadComplete = '1') then
                if ((we_i = Disable) and (re_i = Disable)) then
                     ram1_addr <= "00" & addr_id;
                     -- ram1_addr <= "00" & ZeroWord;
                else
                     ram1_addr <= "00" & addr_i;
                end if;
                if ((we_i = Disable) and (re_i = Disable)) then
                    read_prep <= Disable;
                    write_prep <= Disable;
                    ram1_en <= '0';
                    ram1_oe <= '0';
                    ram1_data <= (others => 'Z');
                elsif (we_i = Enable) then
                    if (addr_i = x"bf00") then
                        -- write serial
                        ram1_en <= '1';
                        ram1_oe <= '1';
                        ram1_data <= data_i;
                        read_prep <= Disable;
                        write_prep <= Enable;
                    elsif(addr_i = x"bf04") then
                        -- write vga data
                        ram1_en <= '0';
                        ram1_oe <= '1';
                        VGAData <= (others => data_i(15));
                        VGAPos_tmp <= "000" & data_i(12 downto 0);
                        read_prep <= Disable;
                        write_prep <= Disable;
                    -- elsif (addr_i = x"bf04") then
                    --     --дVGA��ַ
                    --     ram1_en <= '0';
                    --     ram1_oe <= '1';
                    --     VGAPos_tmp <= data_i;
                    --     read_prep <= Disable;
                    --     write_prep <= Disable;
                    -- elsif (addr_i = x"bf05") then
                    --     --дVGA����
                    --     ram1_en <= '0';
                    --     ram1_oe <= '1';
                    --     VGAData1 <= data_i;
                    --     read_prep <= Disable;
                    --     write_prep <= Disable;
                    else
                        --write real data
                        ram1_en <= '0';
                        ram1_oe <= '1';
                        ram1_data <= data_i;
                        read_prep <= Disable;
                        write_prep <= Disable;
                    end if;
                elsif (re_i = Enable) then
                    if (addr_i = x"bf00") then
                        -- read serial
                        ram1_en <= '1';
                        ram1_oe <= '1';
                        ram1_data <= (others => 'Z');
                        read_prep <= Enable;
                        write_prep <= Disable;
                    -- elsif (addr_i = x"bf06") then
                    --     --������
                    --     ram1_en <= '0';
                    --     ram1_oe <= '1';
                    --     ram1_data <= ASCIIout;
                    --     read_prep <= Disable;
                    --     write_prep <= Disable;
                    elsif (addr_i = x"bf01") then
                        -- prepare to read or write serial
                        ram1_en <= '0';
                        ram1_oe <= '1';
                        read_prep <= Disable;
                        write_prep <= Disable;

                        if ((data_ready = '1') and (tbre = '1') and (tsre= '1')) then
                            -- serial enable write read
                            ram1_data <= x"0003";
                        elsif ((tbre = '1') and (tsre= '1')) then
                            -- serial only write
                            ram1_data <= x"0001";
                        elsif (data_ready = '1') then
                            -- serial only read
                            ram1_data <= x"0002";
                        else
                            -- serial cannot read write
                            ram1_data <= (others => '0');
                        end if;
                    else
                        -- read real data
                        ram1_en <= '0';
                        ram1_oe <= '0';
                        ram1_data <= (others => 'Z');
                        read_prep <= Disable;
                        write_prep <= Disable;
                    end if;
                else
                    -- shouldn't reach here
                    ram1_en <= '0';
                    ram1_oe <= '0';
                    ram1_data <= (others => 'Z');
                    read_prep <= Disable;
                    write_prep <= Disable;
                end if;
            else
                -- read  kernel
                ram1_addr <= "00" & i(18 downto 3);
                ram1_data <= FlashDataOut;
                read_prep <= Disable;
                write_prep <= Disable;
                ram1_en <= '0';
                ram1_oe <= '1';
            end if;
        end if;
    end process;

    -- Ram2EN <= '0';
    -- Ram2WE_control: process(rst, clk, LoadComplete, i)
    -- begin
    --     if (rst = Enable) then
    --         Ram2WE <= '1';
    --     elsif ((LoadComplete = '0') and (i(18 downto 3) < fullInstNum)) then
    --         Ram2WE <= clk;
    --     else
    --         Ram2WE <= '1';
    --     end if;
    -- end process;
    --
    -- VGA_data: process(Ram2data)
    -- begin
    --     VGAData <= Ram2Data;
    -- end process;
    --
    -- Ram2_control: process(rst, LoadComplete, FlashDataOut, i, VGAAddr, Ram2Data)
    -- begin
    --     if (rst = Enable) then
    --         Ram2OE <= '1';
    --         Ram2Addr <= (others => '0');
    --         Ram2Data <= (others => 'Z');
    --     else
    --         if (LoadComplete = '1') then
    --             Ram2OE <= '0';
    --             Ram2Addr <= VGAAddr;
    --             Ram2Data <= (others => 'Z');
    --         else
    --             --��kernel
    --             Ram2Addr <= "00" & i(18 downto 3);
    --             Ram2Data <= FlashDataOut;
    --             Ram2OE <= '1';
    --         end if;
    --     end if;
    -- end process;

    Mem_read : process(rst,addr_id,addr_i,re_i,data_i,ram1_data)
    -- Mem_read : process(rst,addr_i,re_i,data_i,ram1_data)
    variable id : integer;
    begin
        data_o <= ram1_data;
    end process;

    Inst: process(rst,ce_id,rom_ready,ram1_data,LoadComplete)
    begin
        if((ce_id = Enable) and (rst = Disable) and (LoadComplete = Enable) and (rom_ready = Enable)) then
            inst_id <= ram1_data;
        else
            inst_id <= NopInst;
        end if;
    end process;

    Flash_init: process(clk_8,clk,FlashDataOut,rst,i,LoadComplete)
    begin
        if (rst = Enable) then
            FlashAddrIn <= (others => '0');
            LoadComplete <= '0';
            FlashReset <= '0';
            i <= (others => '0');
        else
            if (LoadComplete = '1') then
                FlashReset <= '0';
            else
                if (i(18 downto 3) = fullInstNum) then
                    FlashReset <= '0';
                    LoadComplete <= '1';
                    FlashAddrIn <= (others => '0');
                else
                    FlashReset <= '1';
                    FlashAddrIn <= "000000" & i(18 downto 3);
                    if (clk_8'event and (clk_8 = '1')) then
                        if (i(2 downto 0) = "001") then
                            FlashRead <= not(FlashRead);
                        end if;
                        i <= i + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
