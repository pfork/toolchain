# builds a cross-compiler toolchain #

There is a shellscript which downloads/builds a complete arm-none-eabi
cross-compiler toolchain in: `tchain.sh`

the results will be installed in 'arm/', so you can set your '$PATH' to
`<pathto>/toolchain/arm/bin/arm-none-eabi/`

# for scripting debugging #

in case you have a blackmagic jtag debugger (highly recommended) you
can use pyrsp to make your debug sessions more fluid.

# for debugging NRF24 communications #

You can use use the sub-module in NRF-BTLE-Decoder.

if you have some gnuradio compatible SDR that can tune to 2.4GHz then
you can use nrf2stdout.py to feed the nrf24-btle-decoder like this:

```
$ nrf2stdout.py | ./bin/nrf24-btle-decoder -d 1
```

you can play with nrf2stdout.grc in the gnuradio-companion if you need finetuning.

happy sniffing!
