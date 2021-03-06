require 'ostruct'

class PeopleController < ApplicationController

  def index
    @people = Person.all :conditions => ["name LIKE ? OR last_name LIKE ?",
      "%#{params[:search]}%", "%#{params[:search]}%"], :limit => 10,
      :order => "name, last_name"
  end

  def new
    @person = Person.new
    @person.setup_child_elements
  end

  def create
    @person = Person.new(params[:person])
    respond_to do |format|
      if @person.save
        flash[:notice] = t('people.create.flash.notice', :default => 'Company created.')
        format.html { redirect_to(@person) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        @person.setup_child_elements
        flash[:error] = t('people.create.flash.error', :default => 'Company not created')
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @person = Person.find_by_id(params[:id])
  end

  def edit
    @person = Person.find_by_id(params[:id])
    @person.setup_child_elements
  end

  def update
    @person = Person.find_by_id(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = t('people.update.flash.notice', :default => 'Company updated.')
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        @person.setup_child_elements
        flash[:error] = t('people.update.flash.error', :default => 'Company not updated.')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

end
