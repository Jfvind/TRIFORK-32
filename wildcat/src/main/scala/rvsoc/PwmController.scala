package rvsoc

import chisel3._ 
import chisel3.util._ 

/**
|* 
|* Generates PWM signals by comparing a free-running 8-bit counter
|* against a duty cycle value for each channel.
|* Output is HIGH when counter < duty, LOW otherwise.
|* 
|* At 100 MHz clock: PWM frequency = 100 MHz / 256 = 390 kHz
|* 
|* @param channels number of independents PWM outputs (deafault 16 for LED 0 - 15)
*/

class PwmController (channels: Int = 16) extends Module {
    val io = IO(new Bundle {
        val duty    = Input(Vec(channels, UInt(8.W))) // Each channel has 8-bit wide registers, for 8-bit (256 step) pwm-control resolution
        val pwmOut = Output(UInt(channels.W)) // One concuted "channel" bit wide signal
    })

    // Free running 8-bit counter: counts 0 -> 255 -> 0 -> 255 -> ...
    val counter = RegInit(0.U(8.W))
    counter := counter + 1.U

    // Per-channel comparator: HIGH when counter < duty cycle
    val pwmBits = Wire(Vec(channels, Bool()))
    for (i <- 0 until channels) {
        pwmBits(i) := counter < io.duty(i)
    }

    io.pwmOut := pwmBits.asUInt
}