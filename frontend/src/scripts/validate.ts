export type Rule = (value: string, form: HTMLFormElement) => string | null;

export const required = (message: string): Rule => (value) =>
  value.trim() ? null : message;

export const email = (message: string): Rule => (value) =>
  /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim()) ? null : message;

export const phone = (message: string): Rule => (value) =>
  /^(0|\+84)[0-9]{9}$/.test(value.trim().replace(/[\s.-]/g, '')) ? null : message;

export const minLength = (length: number, message: string): Rule => (value) =>
  value.length >= length ? null : message;

export const matches = (fieldName: string, message: string): Rule => (value, form) => {
  const other = form.querySelector('[name="' + fieldName + '"]') as HTMLInputElement | null;
  return other && other.value === value ? null : message;
};

export const accepted = (fieldName: string, message: string): Rule => (_value, form) => {
  const other = form.querySelector('[name="' + fieldName + '"]') as HTMLInputElement | null;
  return other && other.checked ? null : message;
};

export function initAuthForm(
  form: HTMLFormElement,
  rules: Record<string, Rule[]>,
  onSuccess: () => void
): void {
  let submitted = false;

  const fieldOf = (name: string) =>
    form.querySelector('[name="' + name + '"]') as HTMLInputElement | null;

  const errorOf = (name: string) =>
    form.querySelector('[data-error-for="' + name + '"]') as HTMLElement | null;

  const validateField = (name: string): boolean => {
    const field = fieldOf(name);
    const errorEl = errorOf(name);
    if (!field || !errorEl) return true;

    let message: string | null = null;
    for (const rule of rules[name] ?? []) {
      message = rule(field.value, form);
      if (message) break;
    }

    if (message) {
      errorEl.textContent = message;
      errorEl.classList.remove('hidden');
      field.setAttribute('aria-invalid', 'true');
      if (field.type !== 'checkbox') field.classList.add('border-danger-600');
      return false;
    }

    errorEl.textContent = '';
    errorEl.classList.add('hidden');
    field.removeAttribute('aria-invalid');
    field.classList.remove('border-danger-600');
    return true;
  };

  const validateAll = (): boolean => {
    let firstInvalid: HTMLInputElement | null = null;
    Object.keys(rules).forEach((name) => {
      if (!validateField(name) && !firstInvalid) firstInvalid = fieldOf(name);
    });
    if (firstInvalid) (firstInvalid as HTMLInputElement).focus();
    return !firstInvalid;
  };

  form.addEventListener('submit', (event) => {
    event.preventDefault();
    submitted = true;
    if (validateAll()) onSuccess();
  });

  Object.keys(rules).forEach((name) => {
    const field = fieldOf(name);
    field?.addEventListener('blur', () => {
      if (submitted) validateField(name);
    });
    field?.addEventListener('input', () => {
      if (submitted) validateField(name);
    });
  });
}
