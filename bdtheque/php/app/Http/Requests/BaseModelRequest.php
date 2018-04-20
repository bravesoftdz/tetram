<?php

namespace BDTheque\Http\Requests;

use BDTheque\Models\BaseModelHandlerTrait;
use Illuminate\Foundation\Http\FormRequest;

abstract class BaseModelRequest extends FormRequest
{
    use BaseModelHandlerTrait;

    protected static $baseModelHandlerSuffix = 'Request';

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        if ($this->isMethod('POST'))
            return self::getModelClass()::getCreateRules();
        else
            return self::getModelClass()::getUpdateRules();
    }
}
