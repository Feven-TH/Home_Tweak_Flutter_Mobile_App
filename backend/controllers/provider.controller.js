const { Provider, User, Category } = require('../models'); // Assumes models/index.js exports these
const { Sequelize, Op } = require('sequelize');

// Create a provider (Service Listing)
exports.createProvider = async (req, res) => {
    try {
        const newProvider = await Provider.create(req.body);
        res.status(201).json(newProvider);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get all providers (Viewing Services)
exports.getAllProviders = async (req, res) => {
    try {
        const providers = await Provider.findAll({
            include:[
                {
                    model: User,
                    as: 'user', // Match the 'as' alias from models/index.js
                    attributes: [] // Don't include the nested user object itself, just pull its username
                },
                {
                    model: Category,
                    as: 'categoryData', // Match the 'as' alias from models/index.js
                    attributes: [] // Don't include the nested category object itself, just pull its name
                }
            ],
            // Define all provider attributes you want to include in the final response
            attributes: [
                'id',
                'userId',
                'categoryId',
                'certificate',
                'location',
                'imageUrl',
                'phoneNumber',
                'hourlyRate',
                'yearsOfExperience',
                'rating',
                'serviceDescription',
                // --- START CHANGES HERE ---
                // Alias User's username as 'username' directly in the provider object
                [Sequelize.literal('`user`.`username`'), 'username'],
                // Alias Category's name as 'category' directly in the provider object
                [Sequelize.literal('`categoryData`.`name`'), 'category']
                // --- END CHANGES HERE ---
            ]
        });
        res.status(200).json(providers);
    } catch (error) {
        console.error("Error fetching all providers:", error.message); // Added detailed logging
        res.status(500).json({ error: error.message });
    }
};


// Get providers by category ID (Filter by Category)
exports.getProvidersByCategory = async (req, res) => {
    try {
        const categoryId = req.params.categoryId;
        const providers = await Provider.findAll({
            where: { categoryId },
            // --- START CHANGES HERE ---
            include:[ // Add includes to this function too if you want username/category for filtered results
                {
                    model: User,
                    as: 'user',
                    attributes: []
                },
                {
                    model: Category,
                    as: 'categoryData',
                    attributes: []
                }
            ],
            attributes: [ // Define attributes for filtered results
                'id',
                'userId',
                'categoryId',
                'certificate',
                'location',
                'imageUrl',
                'phoneNumber',
                'hourlyRate',
                'yearsOfExperience',
                'rating',
                'serviceDescription',
                [Sequelize.literal('`user`.`username`'), 'username'],
                [Sequelize.literal('`categoryData`.`name`'), 'category']
            ]
            // --- END CHANGES HERE ---
        });
        res.status(200).json(providers);
    } catch (error) {
        console.error("Error fetching providers by category:", error.message); // Added detailed logging
        res.status(500).json({ error: error.message });
    }
};

// Update provider (Service Update)
exports.updateProvider = async (req, res) => {
    try {
        const { id } = req.params;
        const [updated] = await Provider.update(req.body, {
            where: { id }
        });
        if (updated) {
            // --- START CHANGES HERE ---
            // If you want username/category in the response of updated provider, add includes/attributes here too
            const updatedProvider = await Provider.findByPk(id, {
                include: [
                    { model: User, as: 'user', attributes: [] },
                    { model: Category, as: 'categoryData', attributes: [] }
                ],
                attributes: [
                    'id', 'userId', 'categoryId', 'certificate', 'location', 'imageUrl',
                    'phoneNumber', 'hourlyRate', 'yearsOfExperience', 'rating', 'serviceDescription',
                    [Sequelize.literal('`user`.`username`'), 'username'],
                    [Sequelize.literal('`categoryData`.`name`'), 'category']
                ]
            });
            // --- END CHANGES HERE ---
            return res.status(200).json(updatedProvider);
        }
        throw new Error('Provider not found');
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Delete provider (Service Deletion)
exports.deleteProvider = async (req, res) => {
    try {
        const { id } = req.params;
        const deleted = await Provider.destroy({
            where: { id }
        });
        if (deleted) {
            return res.status(200).json({ message: 'Provider deleted successfully' });
        }
        throw new Error('Provider not found');
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Search providers by name (extra logic)
exports.searchProviderByUsername = async (req, res) => {
    try {
        const { username } = req.query; // Changed from 'name' to 'username'

        if (!username) {
            return res.status(400).json({ error: 'Username is required.' });
        }

        const provider = await Provider.findOne({ // Changed findAll to findOne
            where: {
                // --- START CHANGES HERE ---
                // Reference the alias 'user' in the where clause
                '$user.username$': {
                    [Op.eq]: username // Exact match (case-sensitive)
                }
                // --- END CHANGES HERE ---
            },
            // --- START CHANGES HERE ---
            include: [
                {
                    model: User,
                    as: 'user', // Match the 'as' alias
                    attributes: []
                },
                {
                    model: Category,
                    as: 'categoryData', // Match the 'as' alias
                    attributes: []
                }
            ],
            attributes: [ // Define attributes for search result
                'id',
                'userId',
                'categoryId',
                'certificate',
                'location',
                'imageUrl',
                'phoneNumber',
                'hourlyRate',
                'yearsOfExperience',
                'rating',
                'serviceDescription',
                [Sequelize.literal('`user`.`username`'), 'username'],
                [Sequelize.literal('`categoryData`.`name`'), 'category']
            ]
            // --- END CHANGES HERE ---
        });

        if (!provider) {
            return res.status(404).json({ message: "Provider not found" });
        }

        res.status(200).json(provider);
    } catch (error) {
        console.error("Error fetching provider by username:", error);
        res.status(500).json({ error: error.message });
    }
};

// Get single provider by ID (Provider Details)
exports.getProviderById = async (req, res) => {
    try {
        const { id } = req.params;
        const provider = await Provider.findByPk(id, {
            // --- START CHANGES HERE ---
            include: [
                {
                    model: User,
                    as: 'user', // Match the 'as' alias
                    attributes: []
                },
                {
                    model: Category,
                    as: 'categoryData', // Match the 'as' alias
                    attributes: []
                }
            ],
            attributes: {
                exclude: ['categoryId', 'createdAt', 'updatedAt'],
                include: [
                    [Sequelize.literal('`user`.`username`'), 'username'],
                    [Sequelize.literal('`categoryData`.`name`'), 'category']
                ]
            }
            // --- END CHANGES HERE ---
        });

        if (provider) {
            return res.status(200).json(provider);
        } else {
            return res.status(404).json({ error: 'Provider not found' });
        }
    } catch (error) {
        console.error("Error fetching provider by ID:", error.message);
        res.status(500).json({ error: error.message });
    }
};