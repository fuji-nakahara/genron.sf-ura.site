import Rails from '@rails/ujs';
import React, { FormEventHandler } from 'react';
import FormSelect from 'react-bootstrap/FormSelect';

type Props = {
  sortingMethod: string;
  handleSortingMethodUpdated: (sortingMethod: string) => void;
  isLoggedIn: boolean;
};

const KadaiWorkCardListSortingMethodSelect: React.FC<Props> = ({
  sortingMethod,
  handleSortingMethodUpdated,
  isLoggedIn,
}: Props) => {
  const handleOnChange: FormEventHandler<HTMLSelectElement> = async (event) => {
    const newSortingMethodName = event.currentTarget.value;
    handleSortingMethodUpdated(newSortingMethodName);

    if (!isLoggedIn) {
      return;
    }

    const headers = new Headers({ 'X-Requested-With': 'XMLHttpRequest' });
    const token = Rails.csrfToken();
    if (token) {
      headers.append('X-CSRF-Token', token);
    }
    const body = new FormData();
    body.append('works_order', newSortingMethodName);

    const response = await fetch('/preference', {
      method: 'PATCH',
      credentials: 'same-origin',
      headers: headers,
      body: body,
    });
    if (!response.ok) {
      throw new Error(`Failed PATCH /preference ${response.status} (${response.statusText})`);
    }
  };

  return (
    <FormSelect size="sm" onChange={handleOnChange} defaultValue={sortingMethod}>
      <option value="default">裏SF創作講座順</option>
      <option value="genron_sf">超・SF作家育成サイト順</option>
      <option value="genron_sf_student">超・SF作家育成サイト受講生順</option>
    </FormSelect>
  );
};

export default KadaiWorkCardListSortingMethodSelect;
