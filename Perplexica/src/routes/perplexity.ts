import express from 'express';
import logger from '../utils/logger';
import { searchPerplexity } from '../lib/perplexity';
import { getPerplexityApiKey } from '../config';

const router = express.Router();

/**
 * Check if Perplexity API is configured
 */
router.get('/status', (req, res) => {
  const apiKey = getPerplexityApiKey();
  res.json({
    configured: !!apiKey && apiKey.trim() !== '',
  });
});

/**
 * Search using Perplexity API
 */
router.post('/search', async (req, res) => {
  try {
    const { query, model = 'sonar' } = req.body;

    if (!query) {
      return res.status(400).json({ error: 'Query is required' });
    }

    const apiKey = getPerplexityApiKey();
    if (!apiKey || apiKey.trim() === '') {
      return res.status(400).json({ error: 'Perplexity API key is not configured' });
    }

    const result = await searchPerplexity(query, model);
    return res.json(result);
  } catch (error) {
    logger.error('Error searching with Perplexity API:', error);
    return res.status(500).json({ error: 'Failed to search with Perplexity API' });
  }
});

export default router; 