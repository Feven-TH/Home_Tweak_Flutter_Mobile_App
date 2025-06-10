const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/booking.controller');

router.post('/', bookingController.createBooking);
router.get('/provider/:providerId', bookingController.getBookingsByProvider);
router.put('/:id/status', bookingController.updateBookingStatus);
router.patch('/reschedule/:id', bookingController.rescheduleBooking);
router.put('/:id/cancel', bookingController.cancelBooking);
router.get('/user/:userId/:status', bookingController.getBookingsByUser); // Now accepts userId AND status as params


module.exports = router;
