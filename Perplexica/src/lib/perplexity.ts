import axios from 'axios';
import { getPerplexityApiKey } from '../config';

interface PerplexityResponse {
  id: string;
  model: string;
  object: string;
  created: number;
  citations: string[];
  choices: {
    index: number;
    finish_reason: string;
    message: {
      role: string;
      content: string;
    };
    delta?: {
      role: string;
      content: string;
    };
  }[];
  usage: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

interface SearchResult {
  result: string;
  links: {
    url: string;
    title: string;
    snippet?: string;
  }[];
}

/**
 * Searches using the Perplexity API
 * @param query The search query
 * @param model The Perplexity model to use (default: sonar)
 * @returns The search results
 */
export const searchPerplexity = async (
  query: string,
  model = 'sonar'
): Promise<SearchResult> => {
  try {
    const apiKey = getPerplexityApiKey();
    
    if (!apiKey) {
      throw new Error('Perplexity API key not found in configuration');
    }

    const response = await axios.post<PerplexityResponse>(
      'https://api.perplexity.ai/chat/completions',
      {
        model,
        messages: [
          {
            role: 'system',
            content: 'You are a search assistant that provides accurate and up-to-date information. Return only factual information with sources.'
          },
          {
            role: 'user',
            content: query
          }
        ],
        temperature: 0.2,
        top_p: 0.9,
        return_related_questions: false,
        stream: false
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`
        }
      }
    );

    // Extract text response and citations from the response
    const result = response.data.choices[0].message.content;
    const links = response.data.citations.map(url => ({
      url,
      title: url,
      snippet: ''
    }));

    return {
      result,
      links,
    };
  } catch (error) {
    console.error('Error querying Perplexity API:', error);
    throw error;
  }
} 