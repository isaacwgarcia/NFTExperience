export interface FormData {
  form_data: Record<string, string>;
}

export interface Experience {
  experience_id: string;
  experience_name: string;
  experience_description: string;
  experience_price: string;
  experience_duration?: string;
  experience_location: string;
}
