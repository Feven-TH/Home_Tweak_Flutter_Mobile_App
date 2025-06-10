// models/index.js (The file that defines your associations)

const sequelize = require('../config/db'); // This is your sequelize instance
const User = require('./user');
const Provider = require('./provider');
const Booking = require('./booking');
const Category = require('./category');

// Define associations
// --- START CHANGES HERE ---
Provider.belongsTo(User, { foreignKey: 'userId', as: 'user' }); // ADDED: as: 'user'
Provider.belongsTo(Category, { foreignKey: 'categoryId', as: 'categoryData' }); // ADDED: as: 'categoryData'

Booking.belongsTo(User, { foreignKey: 'userId' });
Booking.belongsTo(Provider, { foreignKey: 'providerId' });

User.hasMany(Provider, { foreignKey: 'userId' });
User.hasMany(Booking, { foreignKey: 'userId' });
Category.hasMany(Provider, { foreignKey: 'categoryId' });
// --- END CHANGES HERE ---

// Export the models & sequelize instance
module.exports = {
    sequelize,
    User,
    Provider,
    Booking,
    Category
};