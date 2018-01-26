#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Nrf2Stdout
# Generated: Thu Jan 25 15:57:45 2018
##################################################

from gnuradio import analog
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser
import math
import osmosdr


class nrf2stdout(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Nrf2Stdout")

        ##################################################
        # Variables
        ##################################################
        self.nrf_channel = nrf_channel = 81
        self.samp_rate = samp_rate = 8e6
        self.fsk_deviation_hz = fsk_deviation_hz = 170e3
        self.center_freq = center_freq = 2.4e9 + (nrf_channel*1e6)

        ##################################################
        # Blocks
        ##################################################
        self.osmosdr_source_0 = osmosdr.source( args="numchan=" + str(1) + " " + '' )
        self.osmosdr_source_0.set_sample_rate(samp_rate)
        self.osmosdr_source_0.set_center_freq(center_freq, 0)
        self.osmosdr_source_0.set_freq_corr(0, 0)
        self.osmosdr_source_0.set_dc_offset_mode(0, 0)
        self.osmosdr_source_0.set_iq_balance_mode(0, 0)
        self.osmosdr_source_0.set_gain_mode(False, 0)
        self.osmosdr_source_0.set_gain(42, 0)
        self.osmosdr_source_0.set_if_gain(20, 0)
        self.osmosdr_source_0.set_bb_gain(20, 0)
        self.osmosdr_source_0.set_antenna('', 0)
        self.osmosdr_source_0.set_bandwidth(0, 0)
          
        self.low_pass_filter_0 = filter.fir_filter_ccf(4, firdes.low_pass(
        	1, samp_rate, 1.9e6, 100e3, firdes.WIN_HAMMING, 6.76))
        self.blocks_float_to_short_0 = blocks.float_to_short(1, 1000)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_short*1, '/dev/stdout', True)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.analog_quadrature_demod_cf_0 = analog.quadrature_demod_cf(samp_rate/(4*2*math.pi*fsk_deviation_hz/8.0))

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_quadrature_demod_cf_0, 0), (self.blocks_float_to_short_0, 0))    
        self.connect((self.blocks_float_to_short_0, 0), (self.blocks_file_sink_0, 0))    
        self.connect((self.low_pass_filter_0, 0), (self.analog_quadrature_demod_cf_0, 0))    
        self.connect((self.osmosdr_source_0, 0), (self.low_pass_filter_0, 0))    

    def get_nrf_channel(self):
        return self.nrf_channel

    def set_nrf_channel(self, nrf_channel):
        self.nrf_channel = nrf_channel
        self.set_center_freq(2.4e9 + (self.nrf_channel*1e6))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.osmosdr_source_0.set_sample_rate(self.samp_rate)
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, 1.9e6, 100e3, firdes.WIN_HAMMING, 6.76))
        self.analog_quadrature_demod_cf_0.set_gain(self.samp_rate/(4*2*math.pi*self.fsk_deviation_hz/8.0))

    def get_fsk_deviation_hz(self):
        return self.fsk_deviation_hz

    def set_fsk_deviation_hz(self, fsk_deviation_hz):
        self.fsk_deviation_hz = fsk_deviation_hz
        self.analog_quadrature_demod_cf_0.set_gain(self.samp_rate/(4*2*math.pi*self.fsk_deviation_hz/8.0))

    def get_center_freq(self):
        return self.center_freq

    def set_center_freq(self, center_freq):
        self.center_freq = center_freq
        self.osmosdr_source_0.set_center_freq(self.center_freq, 0)


def main(top_block_cls=nrf2stdout, options=None):

    tb = top_block_cls()
    tb.start()
    try:
        raw_input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
