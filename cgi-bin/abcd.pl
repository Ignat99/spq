#! /usr/bin/perl -w

use strict;
use CGI;
use vars qw( $data );
use vars qw( $data_set );
use vars qw( $pq_pos );
use vars qw( $astar_pos );
#use vars qw( $astar_forma );

my %astar_forma;

#$data_set = {	'1_Magnetostatics' => {'1' => '1', '2' => '2'},
#		'3_Electrostatics' => {'1' => '2', '3' => '1'}
#};

my $flag_stop = 0;
my $debug = 0;
my $show_rules =0;
my $debug_astar = 0;
my $w_link = 'abcd_wiki.pl';
my ($h_blue,$h_red) = ('#88FF88','#FF4A4A');

$data = {
  '0_4' => 		{'0' => 'R,l,^,nabla','1' => '','21' => '<','3'=>'','41' => '', '5' => '','61'=> '<','7' => '','81' => '', '9' => '', '9101' => '<','911' => "",'9121' => '',   '913' => '',  '9141' => '<','915' => '', '9161' => '',   '917' => '',      '9181' => '<','919' => '',  '9201' => '',   '921' => '',  '9221' => '<','923' => '',  '9241' => '',   '925'=>'', '9261'=>'<','927'=>'','9281'=>'',  '929'=>'',     '9301'=>'<','931'=>'','93219'=>'', '933'=>'' },
  '2_Lightostatics' => 	{'0' => "Eps_0*c^6",'1' => "",'21' =>'','3' => "",'41' => '<-','5' => "",'61'=> '','7' => "",'81' => '->','9' => "v_ee",'9101' => '', '911' => "v_e",'9121' => '<-', '913' => "T", '9141' => "", '915' => "T_l",'9161' => '->','917' => "N_l",'9181' => '', '919' => "l_1", '9201' => '<-', '921' => "", '9221' => '', '923' => "",  '9241' => '->', '925'=>"S_l",'9261'=>'','927'=>"l_2", '9281'=>'<-','929'=>"",    '9301'=>'','931'=>"",'9321'=>'->','933'=>"" },
  '30_N' => 		{'0' => "Eps_0*c^5",'1' => '','21' => '^','3' => '','41' => '',	'5'=> '','61'=> 'v','7' => '','81' => '', '9' => '', '9101' => '^','911' => '','9121' => '',   '913' => '',  '9141' => 'v','915' => '', '9161' => '',   '917' => '',      '9181' => '^','919' => '',  '9201' => '',   '921' => '',  '9221' => 'v','923' => '',  '9241' => '',   '925'=>'', '9261'=>'^','927'=>'','9281'=>'',  '929'=>'',     '9301'=>'v','931'=>'','9321'=>'', '933'=>'' },
  '3_Elasticostatics' => {'0' => "Eps_0*c^4",'1' => "",'21' =>'','3' => "V3",'41' => '->','5'=> "S_aa",'61'=> '','7' => "S_a",'81' => '<-','9'=> "S",'9101' => '', '911' =>"l1",'9121' => '->', '913' => "Q", '9141' => "", '915' => "F",'9161' => '<-', '917' => "alpha", '9181' => '', '919' => "R", '9201' => '->', '921' => "k", '9221' => '', '923' => "P", '9241' => '<-', '925'=>"R2",'9261'=>'','927'=>"n",'9281'=>'->','929'=>"gamma",'9301'=>'','931'=>"",'9321'=>'<-','933'=>"" },
  '40_I' => 		{'0' => "Eps_0*c^3",'1' => '','21' => 'v','3' => '','41' => '',	'5'=> '','61'=> '^','7' => '','81' => '', '9' => '', '9101' => 'v','911' => '','9121' => '',   '913' => '',  '9141' => '^','915' => '', '9161' => '',   '917' => '',      '9181' => 'v','919' => '',  '9201' => '',   '921' => '',  '9221' => '^','923' => '',  '9241' => '',   '925'=>'', '9261'=>'v','927'=>'','9281'=>'',  '929'=>'',     '9301'=>'^','931'=>'','9321'=>'', '933'=>'' },
  '4_Magnetostatics' => {'0' => "Eps_0*c^2",'1' => "",'21' =>'','3' => "",'41' => '<-','5' => "p_mm",'61'=> '','7' => "p_m",'81' => '->','9' => "L",'9101' => '', '911' => "P_m",'9121' => '<-', '913' => "Phi_m", '9141' => "", '915' => "v_s",'9161' => '->','917' => "I",'9181' => '', '919' => "H", '9201' => '<-', '921' => "B", '9221' => '', '923' => "M_0",  '9241' => '->', '925'=>"j",'9261'=>'','927'=>"divj", '9281'=>'<-','929'=>"J",    '9301'=>'','931'=>"v_m",'9321'=>'->','933'=>"Z_a" },
  '50_1/r' => 		{'0' => "Eps_0*c^1",'1' => '','21' => '^','3' => '','41' => '',	'5'=> '','61'=> 'v','7' => '','81' => '', '9' => '', '9101' => '^','911' => '','9121' => '',   '913' => '',  '9141' => 'v','915' => '', '9161' => '',   '917' => '',       '9181' => '^','919' => '',  '9201' => '',   '921' => '',  '9221' => 'v','923' => '',  '9241' => '',   '925'=>'', '9261'=>'^','927'=>'','9281'=>'',  '929'=>'',     '9301'=>'v','931'=>'','9321'=>'', '933'=>'' },
  '5_Electrostatics' =>  {'0' => "Eps_0*c^0",'1' => "",'21' =>'','3' => "",'41' => '->','5' => "j_e",'61' => '','7' => "P_e",'81' => '<-','9' => "S_m",'9101' => '', '911' => "N",'9121' => '->', '913' => "m", '9141' => "", '915' => "tau",'9161' => '<-', '917' => "phi", '9181' => '', '919' => "E", '9201' => '->', '921' => "D", '9221' => '', '923' => "rho_e", '9241' => '<-', '925'=>"1_eps",'9261'=>'','927'=>"",'9281'=>'->','929'=>"n_rho",'9301'=>'','931'=>"",'9321'=>'<-','933'=>"" },
  '60_' => 		{'0' => "Eps_0*c^-1",'1' => '','21'=> 'v','3' => '','41' => '',	'5'=> '','61'=> '^','7' => '','81' => '', '9' => '', '9101' => 'v','911' => '','9121' => '',   '913' => '',  '9141' => '^','915' => '', '9161' => '',   '917' => '', '9181' => 'v','919' => '',  '9201' => '',   '921' => '',  '9221' => '^','923' => '',  '9241' => '',   '925'=>'', '9261'=>'v','927'=>'','9281'=>'',  '929'=>'',     '9301'=>'^','931'=>'','9321'=>'', '933'=>'' },
  '6_Radiatostatics' => {'0' => "Eps_0*c^-2",'1' => "",'21'=>'','3' => "",'41' => '<-','5' => "",'61'=> '','7' => "",'81' => '->','9' => "",'9101' => '', '911' => "K_ee",'9121' => '<-', '913' => "K_e", '9141' => "", '915' => "v3",'9161' => '->','917' => "1/r",'9181' => '', '919' => "sig", '9201' => '<-', '921' => "D_r", '9221' => '', '923' => "",  '9241' => '->', '925'=>"",'9261'=>'','927'=>"", '9281'=>'<-','929'=>"",    '9301'=>'','931'=>"",'9321'=>'->','933'=>"" },
  '70_' => 		{'0' => "Eps_0*c^-3",'1' => '','21' => '^','3' => '','41' => '',	'5'=> '','61'=> 'v','7' => '','81' => '', '9' => '', '9101' => '^','911' => '','9121' => '',   '913' => '',  '9141' => 'v','915' => '', '9161' => '',   '917' => '',       '9181' => '^','919' => '',  '9201' => '',   '921' => '',  '9221' => 'v','923' => '',  '9241' => '',   '925'=>'', '9261'=>'^','927'=>'','9281'=>'',  '929'=>'',     '9301'=>'v','931'=>'','9321'=>'', '933'=>'' },
  '7_Atomostatics' =>   {'0' => "Eps_0*c^-4",'1' => "",'21' =>'','3' => "",'41' => '->','5' => "",'61' => '','7' => "",'81' => '<-','9' => "",'9101' => '', '911' => "",'9121' => '->', '913' => "1/C", '9141' => "", '915' => "Eps_0",'9161' => '<-', '917' => "", '9181' => '', '919' => "", '9201' => '->', '921' => "", '9221' => '', '923' => "", '9241' => '<-', '925'=>"",'9261'=>'','927'=>"",'9281'=>'->','929'=>"",'9301'=>'','931'=>"",'9321'=>'<-','933'=>"" },
#  '9_0' => 		{},
  'g_1' => 		{'0' => "1",'1'=>'','21'=>'','3'=>""    ,'41'=>'','5'=>"Inert.m",'61'=>'','7'=>"Dipol.m",'81'=>'','9'=>"Angul.m",'9101'=>'','911'=>"V.quant",'9121'=>'','913'=>"S.quant",'9141'=>"",'915'=>"V.pot",'9161'=>'','917'=>"S.pot",'9181'=>'','919'=>"Tense",'9201'=>'','921'=>"Induc",'9221'=>'','923'=>"Q.den",'9241'=>'','925'=>"P.den"  },
  'g_2' => 		{'0' => "2",'1'=>'','21'=>'','3'=>"2/-3",'41'=>'','5'=>"1/-2",   '61'=>'','7'=>"2/-1",   '81'=>'','9'=>"1/-2",   '9101'=>'','911'=>"2/-1",	 '9121'=>'','913'=>"1/0",    '9141'=>"",'915'=>"2/1",'9161'=>'','917'=>"1/0",'9181'=>'','919'=> "2/1", 	'9201'=>'','921'=>"1/2",'9221'=>'',     '923'=>"2/3",'9241'=>'','925'=>"1/2",'9261'=>'','927'=>"2/3",'9281'=>'','929'=>"1/4"},
  'g_3' => 		{'0' => "3",'1'=>'','21'=>'','3'=>"",'41'=>'','5'=>'', 		'61' =>'','7'=>"",	'81' => '','9'=>"",	'9101'=>'','911'=>"S_a"	,'9121'=>'','913'=>"E_p",'9141'=>'','915'=>"E_k",'9161'=>"F",'917'=>"k_l",'9181'=>'','919'=> "k_c", '9201' => "P", 	'921' => "f_l",	'9221'=>'', '923'=> 'f_c'  },
};
$astar_pos = {
'1_Imageostatic' => 1,
'2_Lightostatics' => 2,
'3_Elasticostatics'=> 3,
'4_Magnetostatics' => 4,
'5_Electrostatics' => 5,
'6_Radiatostatics' => 6,
'7_Atomostatics'=> 7,
'3' => 1,
'5' => 2,
'7' => 3,
'9' => 4,
'911' => 5,
'913' => 6,
'915' => 7,
'917' => 8,
'919' => 9,
'921' => 10,
'923' => 11,
'925' => 12,
'927' => 13,
'929' => 14,
'931' => 15,
'933' => 16,
};
my @astar_b = (1,3,5,7,9,911,913,915,917,919,921,923,925,927,929,931,933);
my @array_astar=();


my ($p2,$p3,$p4,$p5,$p6,$p7) = ('2_Lightostatics','3_Elasticostatics','4_Magnetostatics','5_Electrostatics','6_Radiatostatics','7_Atomostatics');
my @branch = ('0_4','10_','1_Imageostatic','20_','2_Lightostatics','30_N','3_Elasticostatics','40_I','4_Magnetostatics','50_1/r','5_Electrostatics','60_','6_Radiatostatics','70_','7_Atomostatics');
$pq_pos = {
  'nabla' => { '1' => '0_4', '2' => '0' }, 
  'dl1' => { '1' => '0_4', '2' => '0' }, 

  'v_ee' => { '1' => $p2, '2' => '9' }, 
  'v_e' => { '1' => $p2, '2' => '911' }, 
  'T' => { '1' => $p2, '2' => '913' }, 
  'T_l' => { '1' => $p2, '2' => '915' }, 
  'N_l' => { '1' => $p2, '2' => '917' }, 
  'l_1' => { '1' => $p2, '2' => '919' }, 
  'S_l' => { '1' => $p2, '2' => '925' }, 
  'l_2' => { '1' => $p2, '2' => '927' }, 

  'V3' => { '1' => $p3, '2' => '3' }, 
  'S_aa' => { '1' => $p3, '2' => '5' }, 
  'S_a' => { '1' => $p3, '2' => '7' }, 
  'S' => { '1' => $p3, '2' => '9' }, 
  'l1' => { '1' => $p3, '2' => '911' }, 
  'Q' => { '1' => $p3, '2' => '913' }, 
  'F' => { '1' => $p3, '2' => '915' }, 
  'alpha' => { '1' => $p3, '2' => '917' }, 
  'R' => { '1' => $p3, '2' => '919' }, 
  'k' => { '1' => $p3, '2' => '921' }, 
  'P' => { '1' => $p3, '2' => '923' }, 
  'R2' => { '1' => $p3, '2' => '925' }, 
  'n' => { '1' => $p3, '2' => '927' }, 
  'gamma' => { '1' => $p3, '2' => '929' }, 


  'p_mm' => { '1' => $p4, '2' => '5' }, 
  'p_m' => { '1' => $p4, '2' => '7' }, 
  'L' => { '1' => $p4, '2' => '9' }, 
  'P_m' => { '1' => $p4, '2' => '911' }, 
  'Phi_m' => { '1' => $p4, '2' => '913' }, 
  'v_s' => { '1' => $p4, '2' => '915' }, 
#  'V' => { '1' => $p4, '2' => '917' }, 
  'I' => { '1' => $p4, '2' => '917' }, 
  'H' => { '1' => $p4, '2' => '919' }, 
  'B' => { '1' => $p4, '2' => '921' }, 
  'M_0' => { '1' => $p4, '2' => '923' }, 
  'j' => { '1' => $p4, '2' => '925' }, 
  'divj' => { '1' => $p4, '2' => '927' }, 
  'J' => { '1' => $p4, '2' => '929' }, 
  'v_m' => { '1' => $p4, '2' => '931' }, 
  'Z_a' => { '1' => $p4, '2' => '933' }, 
 
  'j_e' => { '1' => $p5, '2' => '5' },
  'P_e' => { '1' => $p5, '2' => '7' },
  'S_m' => { '1' => $p5, '2' => '9' },
  'N' => { '1' => $p5, '2' => '911' },
  'm' => { '1' => $p5, '2' => '913' }, 
  'tau' => { '1' => $p5, '2' => '915'}, 
  'phi' => { '1' => $p5, '2' => '917'}, 
  'E' => { '1' => $p5, '2' => '919' }, 
  'D' => { '1' => $p5, '2' => '921' }, 
  'rho_e' => { '1' => $p5, '2' => '923' }, 
  '1_eps' => { '1' => $p5, '2' => '925' }, 
  'n_rho' => { '1' => $p5, '2' =>  '929'},
  
  'K_ee' => { '1' => $p6, '2' => '911' }, 
  'K_e' => { '1' => $p6, '2' => '913' }, 
  'v3' => { '1' => $p6, '2' => '915' }, 
  '1/r' => { '1' => $p6, '2' => '917' }, 
  'sig' => { '1' => $p6, '2' => '919' }, 
  'D_r' => { '1' => $p6, '2' => '921' }, 

  '1/C' => { '1' => $p7, '2' => '913' }, 
  'Eps_0' => { '1' => $p7, '2' => '915' }, 
};

# compute physical equations

my @arr_input=();

sub make_arr_input {
    my $data = shift;
    my ($a_part, $tmp_part) = ('',"");
#    my $p_part = '4_Magnetostatics';
    foreach my $p_part (reverse sort keys %$data) {
    next if $p_part =~ /g_/;
    if ($p_part =~ /.0_/) {$a_part = $p_part; next;}; 
    
    my $eps = $data->{$p_part}->{'0'};
    my $eps1 = $data->{$a_part}->{'0'};
    my $dl1 = 'dl1';
    
    my ($last_el, $last_pot, $last_vec,$oper) = ("","","",'*');
    foreach my $cur_pq_n ( sort keys %{$data->{$p_part}} ) {
	 my $cur_el = $data->{$p_part}->{$cur_pq_n};
	 next if $cur_pq_n eq '0';
#	 next if ($cur_el eq '->' and $cur_el eq '<-');
	 if ( $last_el ne "" and $last_pot ne "" and ($cur_el eq '<-' or $cur_el eq '->') and ($last_pot ne '<-' and $last_pot ne '->') ) { 
	    push(@arr_input,[$last_pot,'=',$last_el,'*',$dl1]); 
	    
	    my $id = int $pq_pos->{$last_pot}->{'2'};
	    my $id_el = int $pq_pos->{$last_el}->{'2'};
	    my ($a_sig,$id1) = ('','');
	    if ($id == 9)  {$id1 = '9101'} else { $id1 = ($id+1).'1'}
	    if ($data->{$a_part}->{$id1} eq '^' ) { $a_sig = '*';} else { $a_sig = '/';}
	    push(@arr_input,[$last_pot,'=', $data->{$tmp_part}->{$id}, $a_sig, $eps1]) if (defined $tmp_part and defined $a_part and exists $data->{$tmp_part}->{$id} and $data->{$tmp_part}->{$id} ne ''); 
#	    push(@arr_input,[$last_el,'=', $data->{$tmp_part}->{$id_el}, $a_sig, $eps1]) if (defined $tmp_part and defined $a_part and exists $data->{$tmp_part}->{$id} and $data->{$tmp_part}->{$id} ne ''); 
	    push(@arr_input,[$last_el,'=', $data->{$tmp_part}->{$id_el}, $a_sig, $eps1]) if (defined $tmp_part and defined $a_part and exists $data->{$tmp_part}->{$id_el} and $data->{$tmp_part}->{$id_el} ne ''); 
	 }
	 if ( $last_el ne "" and $cur_el eq "" and $last_vec ne "" and ($last_vec ne '<-' and $last_vec ne '->') and ($last_el ne '<-' and $last_el ne '->' )) 
	 { 
	    if ($oper eq '*' ) {push(@arr_input,[$last_vec,'=',$last_el,'*',$eps]) } else {
	    push(@arr_input,[$last_el,'=',$last_vec,'*',$eps]) }
#	    push(@arr_input,[$last_el,'=',$last_vec,$oper,$eps])};
	 }
	$last_pot = $last_el if ($cur_el eq '' and $last_el ne "" ); 
	if (($cur_el eq '<-' or $cur_el eq '->') and $last_el ne "" )
	{	$last_vec = $last_el;
		if ( $cur_el eq '<-') {$oper='*';} else{ $oper='/';}
	} 
	 if ($cur_el ne '->' or $cur_el ne '<-') {$last_el = $cur_el } else {$last_pot = ""};
	 if ($cur_el ne '' ) {$last_el = $cur_el } else {$last_vec = ""};
    }
    $tmp_part = $p_part;
    }
}

&make_arr_input($data);
#my %total_var=("");
#my %total_var=('alpha'=>1);
#my %total_var=('l1'=> 1, 'Eps_0' => 1);
my %total_var=('dl1'=> 1, 'Eps_0*c^0' => 1, 'Eps_0*c^6'=>1,'Eps_0*c^5'=>1,'Eps_0*c^4'=>1,'Eps_0*c^3'=>1,'Eps_0*c^2'=>1,'Eps_0*c^1'=>1,'Eps_0*c^-1'=>1,'Eps_0*c^-2'=>1,'Eps_0*c^-3'=>1,'Eps_0*c^-4'=>1 );

#my %total_var=('T' => 1, 'Eps_0' => 1, 'Eps_0*c^6'=>1,'Eps_0*c^5'=>1,'Eps_0*c^4'=>1,'Eps_0*c^3'=>1,'Eps_0*c^2'=>1,'Eps_0*c^1'=>1,'Eps_0*c^-1'=>1,'Eps_0*c^-2'=>1,'Eps_0*c^-3'=>1,'Eps_0*c^-4'=>1 );
#my %total_var=('N' => 1, 'Sigma' => 1);

my @arr_output = ();
my @astar_input = ();
my @astar_output = ();

sub flip_operation {
	my $sim=shift;
	if ($sim eq '*') { $sim='/';}
	elsif ($sim eq '/') { $sim='*';}
	else {
	die "Parsing error !!!\n";
	}
}

sub make_arr_output {
	my @cur_arr= @_;
	my @tmp_formula;	

	foreach my $cur_line ( @cur_arr) {


		push (@arr_output,[@$cur_line]);
		
		push(@tmp_formula,@$cur_line[2],@$cur_line[1],@$cur_line[0], flip_operation(@$cur_line[3]),@$cur_line[4]);
		push (@arr_output,[@tmp_formula]);

		@tmp_formula=();
		
		push(@tmp_formula,@$cur_line[4],@$cur_line[1],@$cur_line[0], flip_operation(@$cur_line[3]),@$cur_line[2]);
		push (@arr_output,[@tmp_formula]);

		@tmp_formula=();
	}
}

sub make_astar_output {
	my @cur_arr= @_;
	my @tmp_formula;	

	foreach my $cur_line ( @cur_arr) {


		push (@astar_output,[@$cur_line]);
		
		push(@tmp_formula,@$cur_line[2],@$cur_line[1],@$cur_line[0], flip_operation(@$cur_line[3]),@$cur_line[4]);
		push (@astar_output,[@tmp_formula]);

		@tmp_formula=();
		
		if (@$cur_line[3] eq '/' ) { push(@tmp_formula,@$cur_line[4],@$cur_line[1],@$cur_line[2], @$cur_line[3],@$cur_line[0]);}
		else {push(@tmp_formula,@$cur_line[4],@$cur_line[1],@$cur_line[0], flip_operation(@$cur_line[3]),@$cur_line[2]);}
		push (@astar_output,[@tmp_formula]);

		@tmp_formula=();
	}
}


&make_arr_output(@arr_input);

my @isp_form=();
my %isp_gr_form=();
# РўСѓС‚ РґРѕР»Р¶РЅР° Р±С‹С‚СЊ С„СѓРЅРєС†РёСЏ РїРѕ РѕРїСЂРµРґРµР»РµРЅРёСЋ РЅРѕРјРµСЂР° РіСЂСѓРїРїС‹ РїРѕ РЅРѕРјРµСЂСѓ С„РѕСЂРјСѓР»С‹

sub group_number {
		my $chis=shift;	
		my $n = int ($chis/3);
		return $n;
		}
			



# РС‚Рѕ С„СѓРЅРєС†РёСЏ РїРѕРёСЃРєР° РїРѕРґС…РѕРґСЏС‰РёС… С„РѕСЂРјСѓР» (РќР° РѕСЃРЅРѕРІР°РЅРёРё РІС…РѕР¶РґРµРЅРёСЏ СѓРїРѕСЂСЏРґРѕС‡РµРЅРЅС‹С… СЃРёРјРІРѕР»РѕРІ)
sub search_number_of_formula {
	my ($simbol1,$simbol2,$simbol3)=@_;
	my @isp_form;
	my $i=0;
	my @search_condition; 
	my ($cur_iter1,$cur_iter2,$cur_iter3);

#print "Sim: $simbol1\n";

	if (defined $simbol1) { push (@search_condition, '$cur_iter1 eq $simbol1'); } 
	else {die "Simbol1 not defined : $! \n";}

	if (defined $simbol2) { push (@search_condition, '$cur_iter2 eq $simbol2'); }

	if (defined $simbol3) { push (@search_condition, '$cur_iter3 eq $simbol3'); }

	
	foreach my $iter (@arr_output){
		$cur_iter1 = @$iter[0];
		$cur_iter2 = @$iter[2];
		$cur_iter3 = @$iter[4];

	
		if (  
			eval (join ( " and ", @search_condition) ) 
		) {
			push (@isp_form,$i);
		} else {
		}
		$i++;
	}
	return @isp_form;
}
sub astar_search_number_of_formula {
	my ($simbol1,$simbol2,$simbol3)=@_;
	my @isp_form;
	my $i=0;
	my @search_condition; 
	my ($cur_iter1,$cur_iter2,$cur_iter3);

#print "Sim: $simbol1\n";

	if (defined $simbol1) { push (@search_condition, '$cur_iter1 eq $simbol1'); } 
	else {die "Simbol1 not defined : $! \n";}

	if (defined $simbol2) { push (@search_condition, '$cur_iter2 eq $simbol2'); }

	if (defined $simbol3) { push (@search_condition, '$cur_iter3 eq $simbol3'); }

	
	foreach my $iter (@astar_output){
		$cur_iter1 = @$iter[0];
		$cur_iter2 = @$iter[2];
		$cur_iter3 = @$iter[4];

	
		if (  
			eval (join ( " and ", @search_condition) ) 
		) {
			push (@isp_form,$i);
		} else {
		}
		$i++;
	}
	return @isp_form;
}
sub astar_cond {
    my ($ni,$x,$y)=@_;
    my $val = $array_astar[$x]->[$y];
    if ($val == 253) { goto ETAP_9;}
    if ($val == 254) { $array_astar[$x]->[$y]= $ni+1;}
}
sub astar_data {
    my ($x,$y)=@_;
    my $cur;
    $cur='1_Imageostatic' if ($x == 1);
    $cur=$p2 if ($x == 2);
    $cur=$p3 if ($x == 3);
    $cur=$p4 if ($x == 4);
    $cur=$p5 if ($x == 5);
    $cur=$p6 if ($x == 6);
    $cur=$p7 if ($x == 7);
    return $data->{$cur}->{$astar_b[$y]};
}
sub init_array_astar {
    @array_astar=();
    for (my $i=1;$i<=7;$i++)
    {
	for (my $j=1;$j<=16;$j++)
	{
	    $array_astar[$i]->[$j]=254;
	}
    }
    for (0..16){ $array_astar[0]->[$_]=255; }
    for (1..7){ $array_astar[$_]->[0]=255; }
    $array_astar[5]->[1]=255;
    $array_astar[4]->[1]=255;
    $array_astar[4]->[2]=255;
    $array_astar[6]->[3]=255;
    $array_astar[6]->[4]=255;
    $array_astar[6]->[5]=255;
    $array_astar[6]->[6]=255;

#$array_astar[3]->[2]=255;
#$array_astar[4]->[2]=255;
#$array_astar[3]->[2]=255;
}
sub branch_astar {
    my($b_el,$s_el,%isp_gr_form)=@_;
    &init_array_astar;
#    if ( exists $total_var{$b_el} ) { return $b_el;}
    my $data_x =  $pq_pos->{$b_el}->{'2'};
    my $data_y =  $pq_pos->{$b_el}->{'1'};
    my $astar_x = int $astar_pos->{$data_x};
    my $astar_y = int $astar_pos->{$data_y};

    my $data_xs =  $pq_pos->{$s_el}->{'2'};
    my $data_ys =  $pq_pos->{$s_el}->{'1'};
    my $astar_xs = int $astar_pos->{$data_xs};
    my $astar_ys = int $astar_pos->{$data_ys};

    $array_astar[$astar_y]->[$astar_x]=0;
    $array_astar[$astar_ys]->[$astar_xs]=253;
    
    my ($X0,$Y0,$X1,$Y1)=($astar_ys,$astar_xs,0,0);
    $array_astar[$X0]->[$Y0]=253;
    
    my ($ni,$nk) = (0,64);
while ($ni <= $nk)
{
    for (my $i=1;$i<=7;$i++)
    {
	for (my $j=1;$j<=16;$j++)
	{
	    if ($array_astar[$i]->[$j] == $ni) 
	    {
		&astar_cond($ni,$i+1, $j);
		&astar_cond($ni,$i-1, $j);
		&astar_cond($ni,$i, $j+1);
		&astar_cond($ni,$i, $j-1);
#		&astar_print if $debug_astar;
	    }
	}
    }
    $ni++;
    if ($ni > $nk){ print 'Error 3<br>'; last;}
}
ETAP_9:
    &astar_print if $debug_astar;
    my @forma=();
    my @astar_input_tmp=();
    my $index_f = 0;
    %astar_forma=();
    my $cur_forma_f=&astar_data($X0,$Y0);
    while ($array_astar[$X1]->[$Y1] != 0 ) 
    {
	$X1 = $X0+1; $Y1 = $Y0;
	print $X1,'__',$Y1, '___',&astar_data($X1,$Y1),'<br>'if $debug_astar;
	if ($array_astar[$X0+1]->[$Y0] > $array_astar[$X0-1]->[$Y0]) {$X1 = $X0-1; $Y1 = $Y0;}
	if ($array_astar[$X0-1]->[$Y0] > $array_astar[$X0]->[$Y0+1]) {$X1 = $X0; $Y1 = $Y0+1;}
	if ($array_astar[$X0]->[$Y0+1] > $array_astar[$X0]->[$Y0-1]) {$X1 = $X0; $Y1 = $Y0-1;}
	@forma=&search_number_of_formula(&astar_data($X1,$Y1),&astar_data($X0,$Y0));
	if ($debug_astar) {    foreach my $c_l (@forma) { my $fd=$arr_output[$c_l];  print  @$fd, "; "; }print  '<br>';}
	foreach my $c_l (@forma) 
	{ 
	    my $fd=$arr_output[$c_l];
	    push (@astar_input_tmp, [@$fd]); #Ignat
	    $cur_forma_f ='('. $cur_forma_f.' '.@$fd[3].' '.@$fd[4].')';
	    unless (exists $astar_forma{@$fd[4]}) { $astar_forma{@$fd[4]} = 0;}
	    if (@$fd[3] eq '*'){ $astar_forma{@$fd[4]}=int($astar_forma{@$fd[4]})+1;} else { $astar_forma{@$fd[4]}=int($astar_forma{@$fd[4]})-1;}
	}
	$X0 = $X1; $Y0 = $Y1;
    }
#	if ($debug_astar) {    
	foreach my $c_l (keys %astar_forma) 
	{
	    if (int $astar_forma{$c_l} == 0 ) {delete $astar_forma{$c_l};}
	}
	foreach my $c_l (keys %astar_forma) 
	{
	    if ($c_l eq 'dl1') 
	    {
		if(int $astar_forma{$c_l} == 1)
		{
		    unless (exists $astar_forma{'l1'}) { $astar_forma{'l1'} = 0;}
		    $astar_forma{'l1'}++;
		    delete $astar_forma{$c_l};
		}
		elsif(int $astar_forma{$c_l} == -1)
		{
		    unless (exists $astar_forma{'l1'}) { $astar_forma{'l1'} = 0;}
		    $astar_forma{'l1'}--;
		    delete $astar_forma{$c_l};
		}
		else 
		{
		    unless (exists $astar_forma{'l1'}) { $astar_forma{'l1'} = 0;}
		    $astar_forma{'l1'}= int $astar_forma{$c_l};
		    delete $astar_forma{$c_l};
		}
	    }
	}
	my ($power,$power1,$power_1,$power2,$power_2) =('','','','','');
	my $power_number = 0;
	print "<br\>Astar_Forma0<br\>keys: ", keys %astar_forma, "<br\> value: ", values %astar_forma if ($debug==2);
#	my $iii = 0;
#	while ( $iii < 3 ) { $iii++;
	foreach my $c_l (keys %astar_forma) 
	{
	    if($c_l ne 'l1') 
	    {
		if (int $astar_forma{$c_l} != 0 ) 
		{
		    $power = $c_l =~ /^Eps_0\*c\^(.*\d)$/;
		    $power_number = int $1;
		    $power = 'Eps_0*c^';
		    $power1 = $power.($power_number+1);
		    $power_1 = $power.($power_number-1);
		    $power2 = $power.($power_number+2);
		    $power_2 = $power.($power_number-2);
		    $power = $c_l;
		    if ( $astar_forma{$power2} != 0) 
		    {
#			unless (exists $astar_forma{'v_s'}) { $astar_forma{'v_s'} = 0;}
			unless (exists $astar_forma{'E'}) { $astar_forma{'E'} = 0;}
			unless (exists $astar_forma{'l1'}) { $astar_forma{'l1'} = 0;}
			if ($astar_forma{$power2} > 0) { $astar_forma{$power2}--; $astar_forma{$power}++; $astar_forma{'E'}++;$astar_forma{'l1'}++;}
			else { $astar_forma{$power2}++; $astar_forma{$power}--; $astar_forma{'E'}--;$astar_forma{'l1'}--;}
			goto VICH;
		    }
		    elsif ( $astar_forma{$power1} != 0) 
		    {
			unless (exists $astar_forma{'v_s'}) { $astar_forma{'v_s'} = 0;}
			if ($astar_forma{$power1} > 0) { $astar_forma{$power1}--; $astar_forma{$power}++; $astar_forma{'v_s'}++;}
			else { $astar_forma{$power1}++; $astar_forma{$power}--; $astar_forma{'v_s'}--;}
			goto VICH;
		    }
		    elsif ( $astar_forma{$power_1} != 0) 
		    {
			unless (exists $astar_forma{'v_s'}) { $astar_forma{'v_s'} = 0;}
			if ($astar_forma{$power_1} < 0) { $astar_forma{$power_1}++; $astar_forma{$power}--; $astar_forma{'v_s'}++;}
			else { $astar_forma{$power_1}--; $astar_forma{$power}++; $astar_forma{'v_s'}--;}
			goto VICH;
		    }
		    elsif ( $astar_forma{$power_2} != 0) 
		    {
			unless (exists $astar_forma{'v_s'}) { $astar_forma{'v_s'} = 0;}
			if ($astar_forma{$power_2} < 0) { $astar_forma{$power_2}++; $astar_forma{$power}--; $astar_forma{'v_s'}=+2;}
			else { $astar_forma{$power_2}--; $astar_forma{$power}++; $astar_forma{'v_s'}=-2;}
			goto VICH;
		    }
		    else {;}
#		    print "<br/> Astar_Forma <br/>", %astar_forma;
		}
	    }
	}
#	}
VICH:
	print "<br\>Astar_Forma1<br\>keys: ", keys %astar_forma, "<br\> value: ", values %astar_forma if ($debug==2);
	foreach my $c_l (keys %astar_forma) 
	{
	    if (int $astar_forma{$c_l} == 0 ) {delete $astar_forma{$c_l};}
	    else {;}
	}
	foreach my $c_l (keys %astar_forma)
	{   if ($c_l eq 'l1') 
	    {
		if(int $astar_forma{$c_l} == 2)
		{
		    unless (exists $astar_forma{'S'}) { $astar_forma{'S'} = 0;}
		    $astar_forma{'S'}++;
		    delete $astar_forma{$c_l};
		}
#		elsif(int $astar_forma{$c_l} == 3 )
#		{
#		    unless (exists $astar_forma{'V3'}) { $astar_forma{'V3'} = 0;}
#		    $astar_forma{'V3'}++;
#		    delete $astar_forma{$c_l};
#		    unless (exists $total_var{'V3'}) {@astar_input = (['V3',"=",'S','*','l1'],@astar_input);}
#		    unless (exists $total_var{'S'}) {@astar_input = (['S',"=",'l1','*','l1'],@astar_input);}
#		}
#		elsif(int $astar_forma{$c_l} == -2)
#		{
#		    unless (exists $astar_forma{'S'}) { $astar_forma{'S'} = 0;}
#		    $astar_forma{'S'}--;
#		    delete $astar_forma{$c_l};
#		}
#		elsif(int $astar_forma{$c_l} == -3)
#		{
#		    unless (exists $astar_forma{'V3'}) { $astar_forma{'V3'} = 0;}
#		    $astar_forma{'V3'}--;
#		    delete $astar_forma{$c_l};
#		}
		else {;}
	    }
	    else {;}
	}
	foreach my $c_l (keys %astar_forma) 
	{
	    if($c_l ne 'l1') 
	    {
		if (int $astar_forma{$c_l} != 0 ) 
		{
		    $power = $c_l =~ /^Eps_0\*c\^(.*\d)$/;
		    $power_number = int $1;
		    $power = 'Eps_0*c^';
		    $power1 = $power.($power_number+1);
		    $power_1 = $power.($power_number-1);
		    $power2 = $power.($power_number+2);
		    $power_2 = $power.($power_number-2);
		    $power = $c_l;
		    if ( $astar_forma{$power1} != 0 and $astar_forma{$power_1} != 0) 
		    {
			unless (exists $astar_forma{'v_s'}) { $astar_forma{'v_s'} = 0;}
			if ($astar_forma{$power_1} = -1 and $astar_forma{$power1} = 1) 
			{ 
				$astar_forma{$power_1}++; 
				$astar_forma{$power1}--; 
				$astar_forma{'v_s'} = $astar_forma{'v_s'} + 2;
			}
#			else { $astar_forma{$power_2}--; $astar_forma{$power}++; $astar_forma{'v_s'}=-2;}
#			goto VICH;
		    }
		    else {;}
		}
	    }
	}	
	print "<br/>Astar_forma2<br/>keys: ", keys %astar_forma, "<br/> value: ", values %astar_forma if ($debug==2);
	foreach my $c_l (keys %astar_forma) 
	{
	    if (int $astar_forma{$c_l} == 0 ) {delete $astar_forma{$c_l};}
	    else {;}
	}
	foreach my $c_l (keys %astar_forma)
	{
	    if ($c_l eq 'v_s')
	    {
		if(int $astar_forma{$c_l} <= -1 and int $astar_forma{'l1'} >= 1)
		{
		    unless (exists $astar_forma{'T'}) { $astar_forma{'T'} = 0;};
		    $astar_forma{'T'}++;
		    $astar_forma{$c_l}++;
		    $astar_forma{'l1'}--;
		}
		if(int $astar_forma{$c_l} >= 2 and int $astar_forma{'l1'} <= -1)
		{
		    unless (exists $astar_forma{'E'}) { $astar_forma{'E'} = 0;};
		    $astar_forma{'E'}++;
		    $astar_forma{$c_l} = $astar_forma{$c_l} - 2;
		    $astar_forma{'l1'}++;
		}
		if(int $astar_forma{$c_l} >= 1 and int $astar_forma{'l1'} <= -1)
		{
		    unless (exists $astar_forma{'T'}) { $astar_forma{'T'} = 0;};
		    $astar_forma{'T'}--;
		    $astar_forma{$c_l}--;
		    $astar_forma{'l1'}++;
		}
	    }
	}
	print "<br\>Astar_Forma3<br\>keys: ", keys %astar_forma, "<br\> value: ", values %astar_forma if ($debug==2);
	foreach my $c_l (keys %astar_forma) 
	{
	    if (int $astar_forma{$c_l} == 0 ) {delete $astar_forma{$c_l};}
	    else {;}
	}
	print "<br/>Astar_forma4<br/>keys: ", keys %astar_forma, "<br/> value: ", values %astar_forma if ($debug==2);
	my $cur_forma=$b_el.' = '.$s_el;
	$index_f = 1; #keys(%astar_forma);
	my $index_f_1 = 0;
	my $index_f1 = 2;
	foreach my $c_l (keys %astar_forma) 
	{  
#	    next if $c_l eq $s_el;
	    if ( $index_f == 1 and keys(%astar_forma) == 1 ) 
	    { 
		if (int $astar_forma{$c_l} != 0 and int $astar_forma{$c_l} != 1 and int $astar_forma{$c_l} != -1) 
		{
		    print "Vich2_0 " , 
		$cur_forma = $cur_forma .'*('. $c_l.')^'.$astar_forma{$c_l};
			@astar_input = ([$b_el,"=",$s_el,'*','('.$c_l.')^'.$astar_forma{$c_l}],@astar_input);
		} 
		elsif (int $astar_forma{$c_l} == -1)
		{
		    print "Vich-1_0 " , 
		$cur_forma = $cur_forma .' / '. $c_l;
			@astar_input = ([$b_el,"=",$s_el,'/',$c_l],@astar_input);
		}
		elsif (int $astar_forma{$c_l} == 1)
		{
		    print "Vich1_0 " , 
		$cur_forma = $cur_forma .' * '. $c_l; #, '<br>',$b_el,"=",$s_el,'*',$c_l;
			@astar_input = ([$b_el,"=",$s_el,'*',$c_l],@astar_input);
#			@astar_input = ([$b_el,"=",$s_el,'*',$c_l],@astar_input);
		}
		elsif(int $astar_forma{$c_l} == 0){delete $astar_forma{$c_l};}
		else {print 'Error 4_index_f <br>';}
	    }
	    elsif ( $index_f == 1 and keys(%astar_forma) > 1 ) 
	    { 
		if (int $astar_forma{$c_l} != 0 and int $astar_forma{$c_l} != 1 and int $astar_forma{$c_l} != -1) 
		{
#		    print "Vich2_1 " , 
		$cur_forma = $cur_forma .'*('. $c_l.')^'.$astar_forma{$c_l};
			@astar_input = ([$index_f.$b_el,"=",$s_el,'*','('.$c_l.')^'.$astar_forma{$c_l}],@astar_input);
		} 
		elsif (int $astar_forma{$c_l} == -1)
		{
#		    print "Vich-1_1 " , 
		$cur_forma = $cur_forma .' / '. $c_l;
			@astar_input = ([$index_f.$b_el,"=",$s_el,'/',$c_l],@astar_input);
		}
		elsif (int $astar_forma{$c_l} == 1)
		{
#		    print "Vich1_1 " , 
		    $cur_forma = $cur_forma .' * '. $c_l; #, '<br>',$index_f.$b_el,"=",$s_el,'*',$c_l;
			@astar_input = ([$index_f.$b_el,"=",$s_el,'*',$c_l],@astar_input);
#			@astar_input = ([$b_el,"=",$s_el,'*',$c_l],@astar_input);
		}
		elsif(int $astar_forma{$c_l} == 0){delete $astar_forma{$c_l};}
		else {print 'Error 4_index_f <br>';}
	    }
	    elsif ( $index_f < keys(%astar_forma)) 
	    { 
		if (int $astar_forma{$c_l} != 0 and int $astar_forma{$c_l} != 1 and int $astar_forma{$c_l} != -1) 
		{
#		    print "Vich2_i " , 
		    $cur_forma = $cur_forma .'*('. $c_l.')^'.$astar_forma{$c_l};
			@astar_input = ([$index_f.$b_el,"=",$index_f1.$b_el,'*','('.$c_l.')^'.$astar_forma{$c_l}],@astar_input);
		} 
		elsif (int $astar_forma{$c_l} == -1)
		{
#		    print "Vich-1_i " , 
		    $cur_forma = $cur_forma .' / '. $c_l;
			@astar_input = ([$index_f.$b_el,"=",$index_f1.$b_el,'/',$c_l],@astar_input);
		}
		elsif (int $astar_forma{$c_l} == 1)
		{
#		    print "Vich1_i " , 
		    $cur_forma = $cur_forma .' * '. $c_l; #, '<br>',$index_f.$b_el,"=",$index_f1.$b_el,'*',$c_l;
			@astar_input = ([$index_f.$b_el,"=",$index_f1.$b_el,'*',$c_l],@astar_input);
#			@astar_input = ([$b_el,"=",$s_el,'*',$c_l],@astar_input);
		}
		elsif(int $astar_forma{$c_l} == 0){delete $astar_forma{$c_l};}
		else {print 'Error 4_index_f <br>';}
	    }
	    else 
	    { 
#		$s_el=1;
		if (int $astar_forma{$c_l} != 0 and int $astar_forma{$c_l} != 1 and int $astar_forma{$c_l} != -1) 
		{
#		    print "Vich2 " , 
		    $cur_forma = $cur_forma .'*('. $c_l.')^'.$astar_forma{$c_l};
			@astar_input = ([$b_el,"=",'1'.$b_el,'*','('.$c_l.')^'.$astar_forma{$c_l}],@astar_input);
			#@astar_input = (@astar_input_tmp,@astar_input);
		} 
		elsif (int $astar_forma{$c_l} == -1)
		{
#		    print "Vich-1 " , 
		    $cur_forma = $cur_forma .' / '. $c_l;
			@astar_input = ([$b_el,"=",'1'.$b_el,'/',$c_l],@astar_input);
		}
		elsif (int $astar_forma{$c_l} == 1)
		{
#		    print "Vich1 " , 
		    $cur_forma = $cur_forma .' * '. $c_l; #,'<br>',$b_el,"=",'1'.$b_el,'*',$c_l;
##			@astar_input = ([$index_f+1,"=",$index_f,'*',$c_l],@astar_input);
			#@astar_input = (@astar_input_tmp,@astar_input);
			@astar_input = ([$b_el,"=",'1'.$b_el,'*',$c_l],@astar_input);
		}
		elsif(int $astar_forma{$c_l} == 0){delete $astar_forma{$c_l};}
		else {print 'Error 4<br>';}
	    }
		$index_f_1 = $index_f;
#		print "<br>Index_f: $c_l ", $index_f++, '<br>';
		$index_f1 = $index_f++;
	}
#	print  '<br>';}
	print "<br/>Vicheslennaya (branch_astar) " ,$cur_forma, '<br>' if ($debug==2);
    return $cur_forma_f;
}
sub astar_print {
foreach my $val (@array_astar) {
    print join("\t,",@$val),'<br>';
    }
}
# РџРѕРёСЃРє РїРѕРґС„РѕСЂРјСѓР», Р·Р°РїРѕР»РЅРµРЅРёРµ С…РµС€Р° РіСЂСѓРїРї, РІС‹Р·РѕРІ СЂРµРєСѓСЂСЃРёРё РґР»СЏ РєР°Р¶РґРѕР№ РЅРѕРІРѕР№ РіСЂСѓРїРїС‹
sub branch {
    my($b_el,%isp_gr_form)=@_;
    my(@poisk_v_shir1,$cur_gr,$cur_form);
# Рђ СЌС‚Рѕ РјС‹ РѕСЃСѓС‰РµСЃС‚РІР»СЏРµРј РїРѕРёСЃРє РїРѕРґС„РѕСЂРјСѓР»
    if ( exists $total_var{$b_el} ) { return $b_el;}
    @poisk_v_shir1=&search_number_of_formula($b_el);

if ($debug==1) {    foreach my $c_l (@poisk_v_shir1) { my $fd=$arr_output[$c_l];  print  @$fd, "; "; }print  '<br>';}

    foreach my $f_num_1 (@poisk_v_shir1) {
	$cur_gr=&group_number($f_num_1);
	unless ( exists $isp_gr_form{$cur_gr}) {
    	    $isp_gr_form{$cur_gr}++;
	    $cur_form=&perebor($f_num_1,%isp_gr_form);
	    print 'B1 ',$cur_form ,'<br>' if $debug==1;
	    next if $flag_stop;
	    return $cur_form;
	} else {
        $isp_gr_form{$cur_gr}++;
	}
    }
}
sub astar_branch {
    my($b_el,%isp_gr_form)=@_;
    my(@poisk_v_shir1,$cur_gr,$cur_form);
# Рђ СЌС‚Рѕ РјС‹ РѕСЃСѓС‰РµСЃС‚РІР»СЏРµРј РїРѕРёСЃРє РїРѕРґС„РѕСЂРјСѓР»
    if ( exists $total_var{$b_el} ) { return $b_el;}
    @poisk_v_shir1=&astar_search_number_of_formula($b_el);

if ($debug==2){ print  "<br/>Poisk v shir ";   foreach my $c_l (@poisk_v_shir1) { my $fd=$astar_output[$c_l];  print @$fd, "; "; }print  '<br>';}

    foreach my $f_num_1 (@poisk_v_shir1) {
	$cur_gr=&group_number($f_num_1);
	unless ( exists $isp_gr_form{$cur_gr}) {
    	    $isp_gr_form{$cur_gr}++;
	    $cur_form=&astar_perebor($f_num_1,%isp_gr_form);
	    print 'astar_B1 ',$cur_form ,'<br>' if $debug==2;
	    next if $flag_stop;
	    return $cur_form;
	} else {
        $isp_gr_form{$cur_gr}++;
	}
    }
}

# Р¤СѓРЅРєС†РёСЏ РґР»СЏ РїРѕРёСЃРєР° РІ РіР»СѓР±РёРЅСѓ Рё С€РёСЂРёРЅСѓ (СЂРµРєСѓСЂСЃРёРІРЅРѕ)
sub perebor {
# Р”Р»СЏ РЅСѓР¶Рґ СЂРµРєСѓСЂСЃРёРё РЅР°РґРѕ Р·Р°РІРµСЃС‚Рё Р»РѕРєР°Р»СЊРЅС‹Р№ С…РµС€ %isp_form
	my ($el,%isp_gr_form)= @_;
	my ($cur_sim1,$cur_sig,$cur_sim2,$cur_form);

	my $link_to_cur_formula=$arr_output[$el];
# print join(' ',%isp_gr_form), '<br>';

    $flag_stop = 0 if $flag_stop == 1;
    print	@$link_to_cur_formula,'<br>' if $debug==1;
#  РўСѓС‚ РґРѕР»Р¶РЅР° Р±С‹С‚СЊ РїСЂРѕРІРµСЂРєР° РїРѕ СѓСЃР»РѕРІРёСЋ  РІС…РѕР¶РґРµРЅРёСЏ @$link_to_cur_formula[2] Рё  РІ РјР°СЃСЃРёРІ @total_var
    $cur_sim1=@$link_to_cur_formula[2];
    print 'cur_sim1  ', $cur_sim1, ' ' if $debug==1; # РџРµСЂРІС‹Р№ С‡Р»РµРЅ С„РѕСЂРјСѓР»С‹
    $cur_sig=@$link_to_cur_formula[3]; # Р—РЅР°Рє
    $cur_sim2=@$link_to_cur_formula[4]; # Р’С‚РѕСЂРѕР№ С‡Р»РµРЅ С„РѕСЂРјСѓР»С‹

    if ( exists $total_var{$cur_sim1} ) { 
	$cur_form = $cur_form.$cur_sim1;
	print '11 :', $cur_form, '<br>' if $debug==1;
    } else {
	$cur_form=&branch($cur_sim1,%isp_gr_form);
	print '12 :',$cur_form, '<br>' if $debug==1;
    }

#  РўСѓС‚ РґРѕР»Р¶РЅР° Р±С‹С‚СЊ РїСЂРѕРІРµСЂРєР° РїРѕ СѓСЃР»РѕРІРёСЋ  РІС…РѕР¶РґРµРЅРёСЏ @$link_to_cur_formula[4] Рё  РІ РјР°СЃСЃРёРІ @total_var
    if ( exists $total_var{$cur_sim2} ) {
	$cur_form = '('.$cur_form . " $cur_sig $cur_sim2)";
	print '21 : flag= ',$flag_stop,	' ',$cur_form, '<br>' if $debug==1;
	$flag_stop = 1 if ( $cur_form =~ m/\(\s\*/ or $cur_form =~ m/\(\s\//  );
	print "FLAG_STOP" if ($flag_stop and $debug==1); 
	return $cur_form;
    } elsif(not $flag_stop) {
print '22 :',	$cur_form = $cur_form.&branch($cur_sim2,%isp_gr_form), '<br>' if $debug==1;
    } else {
	return '';
    }

}

sub astar_perebor {
# Р”Р»СЏ РЅСѓР¶Рґ СЂРµРєСѓСЂСЃРёРё РЅР°РґРѕ Р·Р°РІРµСЃС‚Рё Р»РѕРєР°Р»СЊРЅС‹Р№ С…РµС€ %isp_form
	my ($el,%isp_gr_form)= @_;
	my ($cur_sim1,$cur_sig,$cur_sim2,$cur_form);

	my $link_to_cur_formula=$astar_output[$el];
#	print join(' ',%isp_gr_form), '<br>';

    $flag_stop = 0 if $flag_stop == 1;
    print	"astar_perebor: cur_formula  ",@$link_to_cur_formula,'<br>' if $debug==2;
#  РўСѓС‚ РґРѕР»Р¶РЅР° Р±С‹С‚СЊ РїСЂРѕРІРµСЂРєР° РїРѕ СѓСЃР»РѕРІРёСЋ  РІС…РѕР¶РґРµРЅРёСЏ @$link_to_cur_formula[2] Рё  РІ РјР°СЃСЃРёРІ @total_var
    $cur_sim1=@$link_to_cur_formula[2];
    print 'astar_cur_sim1  ', $cur_sim1, ' ' if $debug==2; # РџРµСЂРІС‹Р№ С‡Р»РµРЅ С„РѕСЂРјСѓР»С‹
    $cur_sig=@$link_to_cur_formula[3]; # Р—РЅР°Рє
    $cur_sim2=@$link_to_cur_formula[4]; # Р’С‚РѕСЂРѕР№ С‡Р»РµРЅ С„РѕСЂРјСѓР»С‹

    if ( exists $total_var{$cur_sim1} ) { 
	$cur_form = $cur_form.$cur_sim1;
	print 'astar_11 :', $cur_form, '<br>' if $debug==2;
    } else {
	$cur_form=&astar_branch($cur_sim1,%isp_gr_form);
	print 'astar_12 :',$cur_form, '<br>' if $debug==2;
    }

#  РўСѓС‚ РґРѕР»Р¶РЅР° Р±С‹С‚СЊ РїСЂРѕРІРµСЂРєР° РїРѕ СѓСЃР»РѕРІРёСЋ  РІС…РѕР¶РґРµРЅРёСЏ @$link_to_cur_formula[4] Рё  РІ РјР°СЃСЃРёРІ @total_var
    if ( exists $total_var{$cur_sim2} ) {
	$cur_form = '('.$cur_form . " $cur_sig $cur_sim2)";
	print 'astar_21 : flag= ',$flag_stop,	' ',$cur_form, '<br>' if $debug==2;
	$flag_stop = 1 if ( $cur_form =~ m/\(\s\*/ or $cur_form =~ m/\(\s\//  );
	print "astar_FLAG_STOP" if ($flag_stop and $debug==2); 
	return $cur_form;
    } elsif(not $flag_stop) {
	$cur_form = $cur_form.' * '.&astar_branch($cur_sim2,%isp_gr_form); #Ignat
print 'astar_22 :',$cur_sim2," : " ,	$cur_form, '<br>' if $debug==2;
	return $cur_form; #Ignat1
    } else {
	return '';
    }

}

# end compute physical equations

sub yel_arrow {
    my $formula = shift;
    my $color = 'yellow';
    my ($x,$y,$y1,$y2)=('','','','');
    my ($br,$br1,$br2) = (0,0,0); my $i=0;
    my @formula = split (/[\(\)]+/, $formula);
    my @point = split (/\s+/,$formula[1]);
#    print join('|',@point);
    if ($point[0] ne '' and $point[0] ne '*' and $point[0] ne '/') {
	    $x=$pq_pos->{$point[0]}->{'1'};$y=$pq_pos->{$point[0]}->{'2'};
    }
    foreach my $bran1 (@branch) {
	if ($bran1 eq $x) {$br=$i;} 
	$i++;
    }
    $br1=$br+1;$br2=$br-1;

		    if ($y eq '9') { $y1 = '9101'; }else{$y1 = (int $y + 1).'1'; }
		    $y2 = (int $y - 1).'1';
#		    my $x1 = (int $x + 1).'';
#		    my $x2 = (int $x - 1).'';

    foreach my $cur (@formula) {
	print $cur,'<br>' if $debug==1;
	my @f1 = split (/\s+/,$cur);

#	if ($debug) 
#	{foreach my $c (@f1) {
#	    print $cur,' :', ' x=',$x,' y=',$y,' y1=',$y1, ' y2=',$y2, ' f1[2]=', $f1[2], ':',$data->{$x}->{'0'}, '<br>';
#	} };
print $branch[$br1],' : ', $branch[$br2],'<br>' if $debug==1;

	    if ($f1[2] eq 'dl1') {
		$data_set->{'0_4'}->{'0'} = $color;
		if ($f1[1] eq '/') { 
		    $data_set->{'0_4'}->{$y1} = $color;
		    if ($y eq '9') {$y = '911' } else {$y = int $y + 2};
		} elsif ($f1[1] eq '*') {
		    $data_set->{'0_4'}->{$y2} = $color;
		    if ($y eq '911') {$y = '9' } else {$y = int $y - 2;}
		} else {
		    print 'Error1<br>' if $debug==1;
		}
	    } elsif ( $f1[2] eq $data->{$x}->{'0'}) {
		$data_set->{$x}->{'0'} = $color;
		print '<br>', 'X=',$x,'Y=',$y,'<br>' if $debug==1;
		if ($f1[1] eq '/' ) { 
		    if ( $data->{$x}->{$y1} eq '<-' ) { if ($y eq '9') {$y = '911' } else {$y = int $y + 2}; $data_set->{$x}->{$y1} = $color;} 
		    elsif ( $data->{$x}->{$y2} eq '->' ) { if ($y eq '911') {$y = '9' } else {$y = int $y - 2};$data_set->{$x}->{$y2} = $color;} 
		} elsif ($f1[1] eq '*' ) {
		    if ( $data->{$x}->{$y1} eq '->' ) { if ($y eq '9') {$y = '911' } else {$y = int $y + 2};$data_set->{$x}->{$y1} = $color;} 
		    if ( $data->{$x}->{$y2} eq '<-' ) { if ($y eq '911') {$y = '9' } else {$y = int $y - 2};$data_set->{$x}->{$y2} = $color;} 
		} else {
		    print 'Error2<br>';
		}
	    } elsif ($f1[2] eq $data->{$branch[$br1]}->{'0'}) {
		$data_set->{$branch[$br1]}->{'0'} = $color;
		    if ( $data->{$x}->{$y1} eq '->' or $data->{$x}->{$y1} eq '<-') { $data_set->{$branch[$br1]}->{$y2} = $color;} 
		    if ( $data->{$x}->{$y2} eq '->' or $data->{$x}->{$y2} eq '<-') { $data_set->{$branch[$br1]}->{$y1} = $color;} 
		$br2 = $br1;
		$br = $br1+1;
		$br1 = $br1+2;
		$x = $branch[$br];
	    } elsif ($f1[2] eq $data->{$branch[$br2]}->{'0'}) {
		$data_set->{$branch[$br2]}->{'0'} = $color;
		    if ( $data->{$x}->{$y1} eq '->' or $data->{$x}->{$y1} eq '<-') { $data_set->{$branch[$br2]}->{$y2} = $color;} 
		    if ( $data->{$x}->{$y2} eq '->' or $data->{$x}->{$y2} eq '<-') { $data_set->{$branch[$br2]}->{$y1} = $color;} 
		$br1 = $br2;
		$br = $br2 - 1;
		$br2 = $br2 - 2;
		$x = $branch[$br];
	    } else {
		print 'Space<br>' if $debug==1;
	    }
	
	    if ($y eq '9') { $y1 = '9101'; }else{$y1 = (int $y + 1).'1'; }
	    $y2 = (int $y - 1).'1';
    }
}



my $q = new CGI;
my ($pq1,$pq2,$pq3,$pq4,$pq5,$pq6,$pq7,$pq8,$pq9,$tpq,$const);
my $formula = "";
my @pq_arr = ();
print $q->header();

&set_paramSPQ();
print &Show_Form();
foreach my $c_l (@arr_input) { print join(" ",@$c_l), "; " if $show_rules==1; }
#my $formula = &branch($tpq);

push (@pq_arr, $pq1) if ($pq1);
push (@pq_arr, $pq2) if ($pq2);
push (@pq_arr, $pq3) if ($pq3);
push (@pq_arr, $pq4) if ($pq4);
push (@pq_arr, $pq5) if ($pq5);
push (@pq_arr, $pq6) if ($pq6);
push (@pq_arr, $pq7) if ($pq7);
push (@pq_arr, $pq8) if ($pq8);
push (@pq_arr, $pq9) if ($pq9);

#formula search for every argument
my $pq_first = $tpq;
foreach my $pq_cur (@pq_arr) {
    $formula = &branch_astar($pq_first,$pq_cur);
    print "<br/>Itog: ",  $formula , '<br>'if ($debug==2);
    $pq_first = $pq_cur;
}
&make_astar_output(@astar_input);
#$flag_stop=1;
#my %isp_gr_form = ();
my $formula1 = &astar_branch($tpq);
print $formula1,"<br><input type=\"submit\" name=\"submit\" value=\"Show\"></fieldset></form>\n";
print &yel_arrow($formula);
foreach my $c_l (@arr_output) { print join(" ",@$c_l), "; " if $show_rules==2; }
foreach my $c_l (@astar_output) { print join(" ",@$c_l), "; " if $show_rules==3; }
print &set_tableSPQ();
print &Show_Footer();


sub set_paramSPQ {
#    my $html="";
    $tpq='alpha';
    foreach my $param ( $q->param ) {
#	$html .= $param;
	next if ($param eq 'submit');
	if ( defined $q->param($param) and $q->param($param) ne "" ) {
	    $pq1=$q->param($param) if ($param eq 'pq1');
	    $pq2=$q->param($param) if ($param eq 'pq2');
	    $pq3=$q->param($param) if ($param eq 'pq3');
	    $pq4=$q->param($param) if ($param eq 'pq4');
	    $pq5=$q->param($param) if ($param eq 'pq5');
	    $pq6=$q->param($param) if ($param eq 'pq6');
	    $pq7=$q->param($param) if ($param eq 'pq7');
	    $pq8=$q->param($param) if ($param eq 'pq8');

	    $tpq=$q->param($param) if ($param eq 'tpq');
	    if ($param eq 'const'){
		$const=$q->param($param);
		if ($const eq '0') {%total_var=();}
	    } 
	}
	if ($param ne 'tpq') {&set_dataSPQ($q->param($param),$h_blue)} else {&set_dataSPQ($q->param($param),$h_red)};
    }
#    return $html;
}

sub set_dataSPQ {
    my $pq = shift;
    my $color = shift;
    $data_set->{ $pq_pos->{$pq}->{'1'} }->{$pq_pos->{$pq}->{'2'}} = $color;
    $total_var{$pq} = 1 if ($color ne $h_red);
}

sub set_tableSPQ {
  my $txt = qq!<table border=1 !; 
  $txt .= qq! >! ;

  foreach my $topval ( sort keys %$data ) {
#    $txt .= '<tr><td><option value='. $topval . '>'.  $topval .' </option><td>';
    $txt .= '<tr><td>'. $topval .'<td>';
    foreach my $topval1 (sort keys %{ $data->{ $topval } }) {
	my $ds = $data_set->{ $topval }->{$topval1};
	my $d = $data->{ $topval }->{$topval1};
	if($ds) {$txt .= '<td bgcolor='.$ds.'>'} else {$txt .= '<td>'}
#	$txt .= '<option value='. $topval1 . '>'.  $data->{ $topval }->{$topval1} .' </option><td>';
	if (exists $pq_pos->{$d}) {
		$txt .= '<a href=\''.$w_link.'?pq='.$d.'\'>';
		$txt .= $d .'</a><td>';
	} else {$txt .= $d .'<td>';}
    }
    $txt .= '</tr>';
  }

  $txt .= "</table>";
  return($txt);
}

sub Show_Form {
  my $html = "";
  $html .= <<EOT;
<HTML>
  <HEAD><title>SPQ Example</title>
</HEAD>
<BODY>
  <form id="spq" action="abcd.pl" method="post">
  <fieldset>
  Physical quantittes :<br>
  pq1 : <input type="text" name="pq1" size="10" value="$pq1" ><br>
  pq2 : <input type="text" name="pq2" size="10" Value="$pq2" ><br>
  pq3 : <input type="text" name="pq3" size="10" Value="$pq3" ><br>
  pq4 : <input type="text" name="pq4" size="10" Value="$pq4" ><br>
  pq5 : <input type="text" name="pq5" size="10" Value="$pq5" ><br>
  pq6 : <input type="text" name="pq6" size="10" Value="$pq6" ><br>
  pq7 : <input type="text" name="pq7" size="10" Value="$pq7" ><br>
  pq8 : <input type="text" name="pq8" size="10" Value="$pq8" ><br>
  pq9 : <input type="text" name="pq9" size="10" Value="$pq9" ><br>
  tpq : <input type="text" name="tpq" size="10" Value="$tpq" > = <!-- br -->
  <!-- input type="submit" name="submit" value="Show" -->
  <!-- input type="reset"><br -->
  <!-- /fieldset -->
  <!-- /form -->
EOT

  return $html;
}

sub Show_Footer {
  print "</body></html>\n";
  return;
}
