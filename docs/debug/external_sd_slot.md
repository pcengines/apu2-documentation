
We have used an external [SD slot)](https://www.sparkfun.com/products/12941)
connected to SD pins on APU2. Unfortunately `CD` and `WP` pins are not exposed
so it is not `exactly` the same situation. However, we have managed to connect
to `CD` pin as well. Leaving `WP` unconnected should not make the difference -
controller will treat card as write-protected, but that is not an issue in this
case. So to make it clear: we have all SD signals (except for `WP` which is left
unconnected) coming from the external SD slot on prototype board.

To make below tests even more similar, we have moved `WP` switch down so even
in internal slot card will be seen as write-protected.

When `GOOD` card is inserted into the external slot it behaves the same (in terms
of command response) as if it would be inserted into APU2 internal slot. No
matter if it is a cold- or warmboot.

When `BAD` card is inserted into the external slot it behaves the same (in terms
of command response) as `GOOD` card. When it is inserted into APU2 internal
slot it does not respond to any command.

We have not managed to boot from the external slot, however. It is possible
that length and quality of joints is not sufficient enough when frequency rises
from initialization 400 kHz to operational frequency.
